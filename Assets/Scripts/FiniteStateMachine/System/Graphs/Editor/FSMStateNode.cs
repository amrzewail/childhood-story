using FiniteStateMachine;
using Scripts.Graphs.Editor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.UIElements;

namespace Scripts.FSM.Graphs.Editor
{
    [System.Serializable]
    public class FSMStateNode : BasicNode
    {
        //public abstract FSMState GetState();

        public FSMState state;

        public List<Port> transitionPorts;
        public Port startPort;
        public Port inheritPort;
        public Port inheritOutPort;

        public Port startPluggerPort;
        public Port updatePluggerPort;
        public Port exitPluggerPort;

        public FSMStateNode(FSMState state)
        {
            this.state = state;


            base.title = this.state.name;
            transitionPorts = new List<Port>();

            Button addPortButton = new Button(() =>
            {
                //var transitions = this.state.transitions.ToList();
                //transitions.Add(new Transition());
                //this.state.transitions = transitions.ToArray();
                AddNewPort("Empty");
                RefreshPorts();
                RefreshExpandedState();
            });
            addPortButton.text = "Add Transition";
            titleContainer.Add(addPortButton);



            var style = Resources.Load<StyleSheet>("StateNodeStyle");
            this.styleSheets.Add(style);
        }

        public override void GeneratePorts()
        {
            UpdatePortsView();
        }

        public override void OnSelected()
        {
            base.OnSelected();

            Selection.activeObject = state;
        }

        private void UpdatePortsView()
        {
            inputContainer.Clear();
            outputContainer.Clear();

            inheritPort = InstantiatePort(Orientation.Horizontal, Direction.Input, Port.Capacity.Single, typeof(FSMState));
            inheritPort.portName = "Inherit";
            inputContainer.Add(inheritPort);



            startPort = InstantiatePort(Orientation.Horizontal, Direction.Input, Port.Capacity.Multi, typeof(FSMTransition));
            startPort.portName = "Start";
            inputContainer.Add(startPort);


            inheritOutPort = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Multi, typeof(FSMState));
            inheritOutPort.portName = "Inherit";
            outputContainer.Add(inheritOutPort);

            startPluggerPort = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Multi, typeof(IFSMPlugger));
            startPluggerPort.portName = "Start Plugger";
            outputContainer.Add(startPluggerPort);

            updatePluggerPort = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Multi, typeof(IFSMPlugger));
            updatePluggerPort.portName = "Update Plugger";
            outputContainer.Add(updatePluggerPort);

            exitPluggerPort = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Multi, typeof(IFSMPlugger));
            exitPluggerPort.portName = "Exit Plugger";
            outputContainer.Add(exitPluggerPort);

            if (state.transitions != null)
            {
                outputContainer.Add(new VisualElement());
                int i = 0;
                foreach (var t in state.transitions)
                {
                    AddNewPort(t.transition != null ? t.transition.name : "Empty");
                    i++;
                }
            }
            RefreshPorts();
            RefreshExpandedState();
        }

        private void AddNewPort(string name)
        {
            var port = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Single, typeof(FSMTransition));
            port.portName = name; 
            outputContainer.Add(port);
            var delete = new Button(() => {
                //var transitions = this.state.transitions.ToList();
                //transitions.RemoveAt(outputContainer.IndexOf(port) - 1);
                //this.state.transitions = transitions.ToArray();
                port.DisconnectAll();
                outputContainer.Remove(port);
                RefreshPorts();
                RefreshExpandedState();
            });
            delete.text = "X";
            port.contentContainer.Add(delete);
            transitionPorts.Add(port);
        }
    }
}