using FiniteStateMachine;
using Scripts.Graphs.Editor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using System.Linq;

namespace Scripts.FSM.Graphs.Editor
{
    [CreateAssetMenu(fileName = "Graph Properties", menuName = "FSM/Graphs/Graph Properties")]
    public class GraphProperties : ScriptableObject
    {
        [SerializeField] FSMState _startState;
        [SerializeField] bool _loadStatesConfigurations;

        public List<FSMStateNode> stateNodes = new List<FSMStateNode>();

        public List<FSMShortStateNode> shortStateNodes = new List<FSMShortStateNode>();

        public List<FSMTransitionNode> transitionNodes = new List<FSMTransitionNode>();

        public List<FSMPluggerNode> pluggerNodes = new List<FSMPluggerNode>();

        public List<StateTransitionLink> stateTransitionLinks = new List<StateTransitionLink>();


        private void OnValidate()
        {
            if (_loadStatesConfigurations) LoadStates();
            _loadStatesConfigurations = false;
        }

        private List<FSMState> _generatedStates = new List<FSMState>();
        private Dictionary<FSMState, string> _statesGUID = new Dictionary<FSMState, string>();
        private Vector3 _currentPosition = Vector3.zero;

        private void LoadStates()
        {
            if (!_startState) return;

            stateNodes.Clear();
            transitionNodes.Clear();
            pluggerNodes.Clear();
            stateTransitionLinks.Clear();

            _generatedStates = new List<FSMState>();
            _statesGUID = new Dictionary<FSMState, string>();
            _currentPosition = Vector3.zero;

            GenerateState(_startState);
        }

        private void GenerateState(FSMState state)
        {
            if (!_generatedStates.Contains(state))
            {
                
                _generatedStates.Add(state);
                string stateGUID = GUID.Generate().ToString();
                _statesGUID[state] = stateGUID;
                if (state.inherit != null)
                {
                    GenerateState(state.inherit);
                    stateTransitionLinks.Add(new StateTransitionLink
                    {
                        outputGUID = _statesGUID[state.inherit],
                        inputGUID = stateGUID,
                        index = 0
                    });
                }

                Vector3 statePosition = _currentPosition;
                _currentPosition += Vector3.right * 400;
                stateNodes.Add(new FSMStateNode(state)
                {
                    GUID = stateGUID,
                    position = statePosition
                });

 
                for (int i = 0; i < state.transitions.Length; i++)
                {
                    string transitionGUID = GUID.Generate().ToString();
                    transitionNodes.Add(new FSMTransitionNode(state.transitions[i].transition)
                    {
                        GUID = transitionGUID,
                        position = statePosition
                    });
                    GenerateState(state.transitions[i].newState);

                    stateTransitionLinks.Add(new StateTransitionLink
                    {
                        outputGUID = stateGUID,
                        inputGUID = transitionGUID,
                        index = i
                    });

                    stateTransitionLinks.Add(new StateTransitionLink
                    {
                        outputGUID = transitionGUID,
                        inputGUID = _statesGUID[state.transitions[i].newState]
                    });
                }
                for(int i = 0; i < 3; i++)
                {
                    List<Object> OnPluggers = null;
                    switch (i)
                    {
                        case 0: OnPluggers = state.OnStartPluggers; break;
                        case 1: OnPluggers = state.OnUpdatePluggers; break;
                        case 2: OnPluggers = state.OnExitPluggers; break;
                    }
                    for (int j = 0; j < OnPluggers.Count; j++)
                    {
                        string pluggerGUID = GUID.Generate().ToString();
                        pluggerNodes.Add(new FSMPluggerNode((IFSMPlugger)OnPluggers[j])
                        {
                            GUID = pluggerGUID,
                            position = statePosition
                        });
                        stateTransitionLinks.Add(new StateTransitionLink
                        {
                            outputGUID = stateGUID,
                            inputGUID = pluggerGUID,
                            index = i
                        });
                    }
                }
            }
        }

        public FSMState[] GetStates()
        {
            string path = AssetDatabase.GetAssetPath(this);
            path = path.Substring(0, path.Length - this.name.Length - ".asset".Length - 1);

            string[] files = Directory.GetFiles(path, "*.asset", SearchOption.AllDirectories);
            List<FSMState> states = new List<FSMState>();

            foreach(string filePath in files)
            {
                var asset = AssetDatabase.LoadAssetAtPath<Object>(filePath);
                if(asset is FSMState)
                {
                    states.Add(asset as FSMState);
                }
            }

            return states.ToArray();
        }
    }

    [System.Serializable]
    public class StateTransitionLink
    {
        public string outputGUID;
        public string inputGUID;
        public int index = 0;
    }
}