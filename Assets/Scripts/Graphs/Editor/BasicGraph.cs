using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;

namespace Scripts.Graphs.Editor
{
    public abstract class BasicGraph : EditorWindow
    {
        protected BasicGraphView _graphView;

        private List<Button> _toolbarButtons;

        protected virtual void OnEnable()
        {
            ConstructGraphView();
            GenerateToolbar();
        }

        protected virtual void OnDisable()
        {
            rootVisualElement.Remove(_graphView);  
        }

        private void ConstructGraphView()
        {
            _graphView = new BasicGraphView
            {
                name = "Basic Graph"
            };
            VisualElementExtensions.StretchToParentSize(_graphView);
            rootVisualElement.Add(_graphView);
        }

        private void GenerateToolbar()
        {
            var toolbar = new Toolbar();
            foreach (Button b in _toolbarButtons)
            {
                toolbar.Add(b);
            }
            rootVisualElement.Add(toolbar);
        }

        protected void AddToolbarButton(Button b)
        {
            if (_toolbarButtons == null) _toolbarButtons = new List<Button>();
            _toolbarButtons.Add(b);
        }
    }
}