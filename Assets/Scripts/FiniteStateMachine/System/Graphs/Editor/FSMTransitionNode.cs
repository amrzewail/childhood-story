using ProjectSigma.Scripts.FiniteStateMachine;
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
    public class FSMTransitionNode : BasicNode
    {
        //public abstract FSMState GetState();

        public FSMTransition transition;

        public Port inPort;
        public Port outPort;

        public FSMTransitionNode(FSMTransition transition)
        {
            this.transition = transition;

            base.title = this.transition.name;


            var style = Resources.Load<StyleSheet>("TransitionNodeStyle");
            this.styleSheets.Add(style);
        }

        public override void GeneratePorts()
        {
            UpdatePortsView();
        }

        public override void OnSelected()
        {
            base.OnSelected();

            Selection.activeObject = transition;
        }

        private void UpdatePortsView()
        {
            inputContainer.Clear();
            outputContainer.Clear();

            inPort = InstantiatePort(Orientation.Horizontal, Direction.Input, Port.Capacity.Multi, typeof(FSMTransition));
            inPort.portName = "In";
            inputContainer.Add(inPort);

            outPort = InstantiatePort(Orientation.Horizontal, Direction.Output, Port.Capacity.Single, typeof(FSMState));
            outPort.portName = "Out";
            outputContainer.Add(outPort);

            RefreshPorts();
            RefreshExpandedState();
        }
    }
}