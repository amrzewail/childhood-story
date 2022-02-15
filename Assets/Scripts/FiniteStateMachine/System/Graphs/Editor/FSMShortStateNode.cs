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
    public class FSMShortStateNode : BasicNode
    {
        //public abstract FSMState GetState();

        public FSMState state;

        public Port startPort;
        public Port inheritOutPort;

        public FSMShortStateNode(FSMState state)
        {
            this.state = state;


            base.title = this.state.name;
            var style = Resources.Load<StyleSheet>("ShortStateNodeStyle");
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

            startPort = InstantiatePort(Orientation.Horizontal, Direction.Input, Port.Capacity.Multi, typeof(FSMState));
            startPort.portName = "Start";
            inputContainer.Add(startPort);

            inheritOutPort = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Multi, typeof(FSMState));
            inheritOutPort.portName = "Inherit";
            outputContainer.Add(inheritOutPort);


            RefreshPorts();
            RefreshExpandedState();
        }
    }
}