using FiniteStateMachine;
using Scripts.Graphs.Editor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace Scripts.FSM.Graphs.Editor
{
    public class FSMGraph : BasicGraph
    {
        private GraphProperties _currentProperties;

        [MenuItem("FSM/Graph")]
        public static void OpenGraphWindow()
        {
            var window = GetWindow<FSMGraph>(false, "FSM Editor", true);
            window.titleContent = new GUIContent("FSM Graph");
        }

        protected override void OnEnable()
        {
            Button selectAssetButton = new Button(() =>
            {
                if (!_currentProperties) return;
                Selection.activeObject = _currentProperties;
            });
            selectAssetButton.text = "Select Asset";
            AddToolbarButton(selectAssetButton);

            Button createStateButton = new Button(OnCreate);
            createStateButton.text = "Create";
            AddToolbarButton(createStateButton);

            Button saveButton = new Button(OnSave);
            saveButton.text = "Save";
            AddToolbarButton(saveButton);

            Button copyButton = new Button(OnCopy);
            copyButton.text = "Copy";
            AddToolbarButton(copyButton);

            Button refreshButton = new Button(() => UpdateView());
            refreshButton.text = "Refresh";
            AddToolbarButton(refreshButton);

            base.OnEnable();

            _graphView.transform.scale = new Vector3(1, 0.95f, 1);
        }

        private void OnGUI()
        {
            if (Event.current.type == EventType.DragUpdated)
            {
                DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
                Event.current.Use();
            }
            else if (Event.current.type == EventType.DragPerform)
            {
                // To consume drag data.
                DragAndDrop.AcceptDrag();
                if (DragAndDrop.paths.Length == DragAndDrop.objectReferences.Length)
                {
                    for (int i = 0; i < DragAndDrop.objectReferences.Length; i++)
                    {
                        Object obj = DragAndDrop.objectReferences[i];
                        if (obj is FSMState)
                        {
                            bool contains = false;
                            foreach(var s in _currentProperties.stateNodes)
                            {
                                if(s.state == ((FSMState)obj))
                                {
                                    contains = true;
                                    break;
                                }
                            }
                            if(_graphView.Nodes.Where(x => x is FSMStateNode).Where(x => ((FSMStateNode)x).state == ((FSMState)obj)).Any())
                            {
                                contains = true;
                            }
                            if (!contains)
                            {
                                AddState((FSMState)obj);
                            }
                            else
                            {
                                AddShortState((FSMState)obj);
                            }
                        }
                        else if (obj is FSMTransition)
                        {
                            AddTransition((FSMTransition)obj);
                        }
                        else if (obj is IFSMPlugger)
                        {
                            AddPlugger((IFSMPlugger)obj);
                        }
                    }
                }
            }
        }

        private void OnCreate()
        {

            EditorUtility.DisplayPopupMenu(new Rect(0, 0, 0, 0), "Assets/Create/FSM", null);

        }

        private void AddState(FSMState state)
        {
            FSMStateNode node = new FSMStateNode(state);
            _graphView.AddNode(node, true);
        }

        private void AddShortState(FSMState state)
        {
            FSMShortStateNode node = new FSMShortStateNode(state);
            _graphView.AddNode(node, true);
        }

        private void AddTransition(FSMTransition transition)
        {
            FSMTransitionNode trans = new FSMTransitionNode(transition);
            _graphView.AddNode(trans, true);
        }

        private void AddPlugger(IFSMPlugger plugger)
        {
            FSMPluggerNode plug = new FSMPluggerNode(plugger);
            _graphView.AddNode(plug, true);
        }

        private void OnSave()
        {
            var nodes = _graphView.nodes.ToList().Cast<BasicNode>().ToList();
            _currentProperties.stateNodes.Clear();
            _currentProperties.shortStateNodes.Clear();
            _currentProperties.transitionNodes.Clear();
            _currentProperties.pluggerNodes.Clear();
            _currentProperties.stateTransitionLinks.Clear();

            foreach (var n in nodes)
            {
                if (n is FSMStateNode)
                {
                    var state = (FSMStateNode)n;
                    state.state.inherit = null;
                    List<Transition> transitions = new List<Transition>();
                    List<Object> startPluggers = new List<Object>();
                    List<Object> updatePluggers = new List<Object>();
                    List<Object> exitPluggers = new List<Object>();

                    _graphView.Edges.Where(x => x.output.node == state).ToList().ForEach(x =>
                    {
                        if (x.input.node is FSMTransitionNode)
                        {
                            var t = new Transition();
                            t.transition = ((FSMTransitionNode)x.input.node).transition;
                            var transitionGUID = ((FSMTransitionNode)x.input.node).GUID;
                            AddTransitionLink(state.GUID, transitionGUID, transitions.Count);

                            var edge2 = _graphView.Edges.Where(y => y.output.node == x.input.node).FirstOrDefault();
                            if (edge2 != null)
                            {
                                if (edge2.input.node is FSMStateNode)
                                {
                                    t.newState = ((FSMStateNode)edge2.input.node).state;
                                    AddTransitionLink(transitionGUID, ((FSMStateNode)edge2.input.node).GUID, 0);
                                }
                                else if (edge2.input.node is FSMShortStateNode)
                                {
                                    t.newState = ((FSMShortStateNode)edge2.input.node).state;
                                    AddTransitionLink(transitionGUID, ((FSMShortStateNode)edge2.input.node).GUID, 0);
                                }
                            }
                            transitions.Add(t);
                        }
                        else if (x.input.node is FSMPluggerNode)
                        {
                            if (x.output == state.startPluggerPort)
                            {
                                startPluggers.Add(((FSMPluggerNode)x.input.node).pluggerObj);
                                AddTransitionLink(state.GUID, ((FSMPluggerNode)x.input.node).GUID, 0);
                            }
                            else if (x.output == state.updatePluggerPort)
                            {
                                updatePluggers.Add(((FSMPluggerNode)x.input.node).pluggerObj);
                                AddTransitionLink(state.GUID, ((FSMPluggerNode)x.input.node).GUID, 1);
                            }
                            else if (x.output == state.exitPluggerPort)
                            {
                                exitPluggers.Add(((FSMPluggerNode)x.input.node).pluggerObj);
                                AddTransitionLink(state.GUID, ((FSMPluggerNode)x.input.node).GUID, 2);
                            }
                        }
                    });
                    _graphView.Edges.Where(x => x.input.node == state).ToList().ForEach(x =>
                    {
                        if (x.output.node is FSMStateNode)
                        {
                            state.state.inherit = ((FSMStateNode)x.output.node).state;
                            AddTransitionLink(((FSMStateNode)x.output.node).GUID, state.GUID, 0);
                        }else if (x.output.node is FSMShortStateNode)
                        {
                            state.state.inherit = ((FSMShortStateNode)x.output.node).state;
                            AddTransitionLink(((FSMShortStateNode)x.output.node).GUID, state.GUID, 0);
                        }
                    });
                    state.state.transitions = transitions.ToArray();
                    state.state.OnStartPluggers = startPluggers;
                    state.state.OnUpdatePluggers = updatePluggers;
                    state.state.OnExitPluggers = exitPluggers;

                    EditorUtility.SetDirty(state.state);
                    _currentProperties.stateNodes.Add(state);
                }
                else if (n is FSMTransitionNode) _currentProperties.transitionNodes.Add((FSMTransitionNode)n);
                else if (n is FSMPluggerNode) _currentProperties.pluggerNodes.Add((FSMPluggerNode)n);
                else if (n is FSMShortStateNode) _currentProperties.shortStateNodes.Add((FSMShortStateNode)n);

            }
            EditorUtility.SetDirty(_currentProperties);
            AssetDatabase.SaveAssets();

            UpdateView();
        }

        private void OnCopy()
        {
            if (!EditorUtility.DisplayDialog("FSM Graph Copy", "Are you sure you want to copy this graph states?", "Yes"))
            {
                return;
            }

            string directory = AssetDatabase.GetAssetPath(_currentProperties);
            directory = directory.Substring(0, directory.Length - _currentProperties.name.Length - ".asset".Length - 1);
            directory += "/FSM/";
            System.IO.Directory.CreateDirectory(directory);
            foreach(var state in _currentProperties.stateNodes)
            {
                var obj = ScriptableObject.Instantiate<FSMState>(state.state);
                AssetDatabase.CreateAsset(obj, directory + state.state.name + ".asset");
                state.state = obj;
            }
            foreach (var transition in _currentProperties.transitionNodes)
            {
                var obj = ScriptableObject.Instantiate<FSMTransition>(transition.transition);
                AssetDatabase.CreateAsset(obj, directory + transition.transition.name + ".asset");
                transition.transition = obj;
            }
            foreach (var plugger in _currentProperties.pluggerNodes)
            {
                var obj = ScriptableObject.Instantiate<ScriptableObject>(plugger.pluggerObj);
                AssetDatabase.CreateAsset(obj, directory + plugger.pluggerObj.name + ".asset");
                plugger.pluggerObj = obj;
            }
            AssetDatabase.Refresh();
        }

        void OnSelectionChange()
        {
            var obj = Selection.activeObject;
            if(obj is GraphProperties)
            {
                _currentProperties = ((GraphProperties)obj);
                UpdateView();
            }
        }

        private void AddTransitionLink(string output, string input, int index)
        {
            _currentProperties.stateTransitionLinks.Add(new StateTransitionLink
            {
                outputGUID = output,
                inputGUID = input,
                index = index
            });
        }

        private void UpdateView()
        {
            _graphView.ClearNodes();
            _graphView.ClearEdges();

            foreach (var transition in _currentProperties.transitionNodes)
            {
                if (transition.transition == null) continue;

                var tempTransition = new FSMTransitionNode(transition.transition);
                tempTransition.GUID = transition.GUID;
                tempTransition.position = transition.position;
                _graphView.AddNode(tempTransition);
            }

            foreach (var state in _currentProperties.stateNodes)
            {
                if (state.state == null) continue;

                var tempState = new FSMStateNode(state.state);
                tempState.GUID = state.GUID;
                tempState.position = state.position;
                _graphView.AddNode(tempState);
            }

            foreach (var state in _currentProperties.shortStateNodes)
            {
                if (state.state == null) continue;

                var tempState = new FSMShortStateNode(state.state);
                tempState.GUID = state.GUID;
                tempState.position = state.position;
                _graphView.AddNode(tempState);
            }

            foreach (var plugger in _currentProperties.pluggerNodes)
            {
                if (plugger.pluggerObj == null) continue;

                var tempPlugger = new FSMPluggerNode((IFSMPlugger)plugger.pluggerObj);
                tempPlugger.GUID = plugger.GUID;
                tempPlugger.position = plugger.position;
                _graphView.AddNode(tempPlugger);
            }

            foreach (var link in _currentProperties.stateTransitionLinks)
            {
                var outputNode = _graphView.GetNodeByGUID(link.outputGUID);
                if (outputNode == null) continue;
                var inputNode = _graphView.GetNodeByGUID(link.inputGUID);
                if (inputNode == null) continue;
                if(outputNode is FSMStateNode)
                {
                    if (inputNode is FSMTransitionNode)
                    {
                        _graphView.LinkNodes(((FSMStateNode)outputNode).transitionPorts[link.index], ((FSMTransitionNode)inputNode).inPort);
                    }
                    else if(inputNode is FSMStateNode)
                    {
                        _graphView.LinkNodes(((FSMStateNode)outputNode).inheritOutPort, ((FSMStateNode)inputNode).inheritPort);
                    }else if (inputNode is FSMPluggerNode)
                    {
                        switch (link.index)
                        {
                            case 0:
                                _graphView.LinkNodes(((FSMStateNode)outputNode).startPluggerPort, ((FSMPluggerNode)inputNode).inPort);
                                break;
                            case 1:
                                _graphView.LinkNodes(((FSMStateNode)outputNode).updatePluggerPort, ((FSMPluggerNode)inputNode).inPort);
                                break;
                            case 2:
                                _graphView.LinkNodes(((FSMStateNode)outputNode).exitPluggerPort, ((FSMPluggerNode)inputNode).inPort);
                                break;
                        }
                    }
                }
                if (outputNode is FSMShortStateNode)
                {
                    if (inputNode is FSMStateNode)
                    {
                        _graphView.LinkNodes(((FSMShortStateNode)outputNode).inheritOutPort, ((FSMStateNode)inputNode).inheritPort);
                    }
                }
                else if (outputNode is FSMTransitionNode)
                {
                    if (inputNode is FSMStateNode)
                    {
                        _graphView.LinkNodes(((FSMTransitionNode)outputNode).outPort, ((FSMStateNode)inputNode).startPort);
                    }else if(inputNode is FSMShortStateNode)
                    {
                        _graphView.LinkNodes(((FSMTransitionNode)outputNode).outPort, ((FSMShortStateNode)inputNode).startPort);
                    }
                }
            }

        }

        //private void DrawState(FSMState state, int row, int column, int rowOffset, int columnOffset, List<ScriptableObject> addedObjects)
        //{
        //    _iterations++;
        //    if (_iterations >= 100) return;
        //    addedObjects.Add(state);

        //    while (state.inherit != null && !addedObjects.Contains(state.inherit))
        //    {
        //        DrawState(state.inherit, row, column, rowOffset + 1, columnOffset - 1, addedObjects);
        //    }

        //    row += rowOffset;
        //    column += columnOffset;
        //    _graphView.AddNode(new FSMStateNode(state), row + rowOffset, column + columnOffset);
        //    //return;
        //    if(state.transitions != null)
        //    {
        //        int rowIndex = 0;
        //        column++;
        //        foreach(var t in state.transitions)
        //        {
        //            if (!addedObjects.Contains(t.transition))
        //            {
        //                DrawTransition(t.transition, row - (rowIndex), column, addedObjects);
        //            }
        //            if (!addedObjects.Contains(t.newState))
        //            {
        //                DrawState(t.newState, row - (rowIndex++), column, rowOffset, columnOffset, addedObjects);
        //            }
        //        }
        //    }
        //}

        //private void DrawTransition(FSMTransition transition, int row, int column, List<ScriptableObject> addedObjects)
        //{
        //    _iterations++;
        //    if (_iterations >= 100) return;
        //    addedObjects.Add(transition);

        //    _graphView.AddNode(new FSMTransitionNode(transition), row, column);
        //}
    }
}