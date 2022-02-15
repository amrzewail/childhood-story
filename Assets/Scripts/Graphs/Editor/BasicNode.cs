using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEngine;

namespace Scripts.Graphs.Editor
{
    [System.Serializable]
    public abstract class BasicNode : Node
    {
        public static Vector3 lastSelectedPosition { get; private set; }

        public string GUID;

        public bool entryPoint { get; set; } = false;

        public Vector3 position;

        public abstract void GeneratePorts();

        public override void OnSelected()
        {
            base.OnSelected();
            lastSelectedPosition = position;
        }

        public override void OnUnselected()
        {
            base.OnUnselected();

            position = base.GetPosition().position;
        }
    }
}