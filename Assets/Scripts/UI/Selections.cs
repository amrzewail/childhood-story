using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace UI
{
    public class Selections : MonoBehaviour
    {
        [SerializeField] int rowsCount = 1;

        private List<Selection> _selections;

        private List<int> _disabledIndecies = new List<int>();

        private int _currentIndex = 0;


        private void Start()
        {
            _selections = GetComponentsInChildren<Selection>().ToList();

            _currentIndex = 0;
            Highlight(0);
        }

        private void Highlight(int index)
        {
            for (int i = 0; i < _selections.Count; i++)
            {

                if (i == index && !_disabledIndecies.Contains(index))
                {
                    _selections[i].Highlight();
                }
                else
                {
                    _selections[i].UnHighlight();
                }
            }
        }

        public void Up()
        {
            _currentIndex--;
            if (_currentIndex < 0) _currentIndex = _selections.Count - 1;

            if (_disabledIndecies.Contains(_currentIndex))
            {
                Up();
                return;
            }

            Highlight(_currentIndex);
        }

        public void Down()
        {
            _currentIndex++;
            _currentIndex %= _selections.Count;

            if (_disabledIndecies.Contains(_currentIndex))
            {
                Down();
                return;
            }

            Highlight(_currentIndex);
        }

        public void Left()
        {
            _currentIndex -= rowsCount;
            if (_currentIndex < 0) _currentIndex = _selections.Count - 1;
            Highlight(_currentIndex);
        }

        public void Right()
        {
            _currentIndex += rowsCount;
            _currentIndex %= _selections.Count;
            Highlight(_currentIndex);
        }

        public void Select()
        {
            if (_disabledIndecies.Contains(_currentIndex)) return;

            _selections[_currentIndex].Select();
        }

        public void Deactivate()
        {
            for (int i = 0; i < _selections.Count; i++)
            {
                if (_disabledIndecies.Contains(i)) continue;
                _selections[i].UnHighlight();
            }
        }

        public void Activate()
        {
            Highlight(_currentIndex);
        }

        public void Activate(int index)
        {
            _currentIndex = index;
            Highlight(_currentIndex);
        }

        public void DisableSelection(int index)
        {
            _disabledIndecies.Add(index);
        }
    }
}