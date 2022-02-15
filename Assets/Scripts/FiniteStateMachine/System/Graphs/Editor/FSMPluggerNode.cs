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
    public class FSMPluggerNode : BasicNode
    {
        //public abstract FSMState GetState();

        public Port inPort;

        public ScriptableObject pluggerObj;

        public FSMPluggerNode(IFSMPlugger plugger)
        {
            pluggerObj = ((ScriptableObject)plugger);
            base.title = pluggerObj.name;


            var style = Resources.Load<StyleSheet>("PluggerNodeStyle");
            this.styleSheets.Add(style);
        }

        public override void GeneratePorts()
        {
            UpdatePortsView();
        }

        public override void OnSelected()
        {
            base.OnSelected();

            Selection.activeObject = pluggerObj;
        }

        private void UpdatePortsView()
        {
            inputContainer.Clear();

            inPort = InstantiatePort(Orientation.Horizontal, Direction.Input, Port.Capacity.Multi, typeof(IFSMPlugger));
            inPort.portName = "In";
            inputContainer.Add(inPort);

            RefreshPorts();
            RefreshExpandedState();
        }
    }
}