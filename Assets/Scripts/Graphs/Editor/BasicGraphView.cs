using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.UIElements.Experimental;
using Object = UnityEngine.Object;

namespace Scripts.Graphs.Editor
{
    public class BasicGraphView: GraphView
    {
        private readonly Vector2 _defaultNodeSize = new Vector2(150, 100);

        public List<Edge> Edges => edges.ToList();
        public List<BasicNode> Nodes => base.nodes.ToList().Cast<BasicNode>().ToList();

        public BasicGraphView()
        {
            styleSheets.Add(Resources.Load<StyleSheet>("Graph"));

            SetupZoom(ContentZoomer.DefaultMinScale * 0.5f, ContentZoomer.DefaultMaxScale * 2);

            VisualElementExtensions.AddManipulator(this, new ContentDragger());
            VisualElementExtensions.AddManipulator(this, new SelectionDragger());
            VisualElementExtensions.AddManipulator(this, new RectangleSelector());

            var grid = new GridBackground();
            Insert(0, grid);


            //AddElement(GenerateEntryPointNode());

        }

        public override List<Port> GetCompatiblePorts(Port startPort, NodeAdapter nodeAdapter)
        {
            var compatiblePorts = new List<Port>();
            ports.ForEach(port =>
            {
                if(startPort != port && startPort.node != port.node && startPort.portType.Equals(port.portType))
                {
                    compatiblePorts.Add(port);
                }
            });
            return compatiblePorts;
        }

        public BasicNode CreateNode<T>(string nodeName) where T : BasicNode
        {
            BasicNode node = default(T);
            node.title = nodeName;
            AddNode(node);
            return node;
        }

        public void AddNode(BasicNode node, bool defaultPosition)
        {
            if (defaultPosition) node.position = BasicNode.lastSelectedPosition;
            AddNode(node);
        }

        public void AddNode(BasicNode node)
        {
            node.GUID = string.IsNullOrEmpty(node.GUID) ? Guid.NewGuid().ToString() : node.GUID;
            node.GeneratePorts();

            //var inputPort = GeneratePort(node, Direction.Input, Port.Capacity.Multi);
            //inputPort.portName = "Input";
            //node.inputContainer.Add(inputPort);
            node.RefreshExpandedState();
            node.RefreshPorts();
            node.SetPosition(new Rect(node.position, _defaultNodeSize));

            AddElement(node);
        }

        public void LinkNodes(Port output, Port input)
        {
            var tempEdge = new Edge
            {
                output = output,
                input = input
            };
            tempEdge?.input.Connect(tempEdge);
            tempEdge?.output.Connect(tempEdge);
            Add(tempEdge);
        }

        public BasicNode GetNodeByGUID(string GUID)
        {
            var nodes = Nodes;
            for (int i = 0; i < nodes.Count; i++)
            {
                if (nodes[i].GUID == GUID)
                {
                    return nodes[i];
                }
            }
            return null;
        }

        public void ClearNodes()
        {
            Nodes.ForEach(n => RemoveElement(n));
        }

        public void ClearEdges()
        {
            Edges.ForEach(e => RemoveElement(e));
        }

    }
}