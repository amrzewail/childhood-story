using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FiniteStateMachine
{
    [System.Serializable]
    public class FSM
    {
        public const string STATE_START_TIME = "STATE_START_TIME";

        [SerializeField] FSMState _startState;

        //private List<FSMState> _currentStateStack;
        private FSMState _currentState;
        private Dictionary<string, object> _data;

        //public FSMState currentState => _currentStateStack.Count > 0 ? _currentStateStack[_currentStateStack.Count - 1] : null;
        public FSMState currentState => _currentState;

        public void Awake()
        {
            //_currentStateStack = new List<FSMState>();
            _data = new Dictionary<string, object>();
        }

        public void Start()
        {
            TransitionToState(_startState);
        }

        public void Update()
        {
            if (currentState != null)
            {
                bool transitioned = false;
                if (currentState.readyToExit)
                {
                    var transition = currentState.CheckTransitions(_data);
                    if(transition != null)
                    {
                        TransitionToState(transition.newState);
                        transitioned = true;
                    }
                }
                if (!transitioned)
                {
                    currentState.OnUpdatePluggers.ForEach(x => (x as IFSMPlugger).Execute(_data));
                    currentState.UpdateState(_data);
                }
            }
        }

        private FSMState InstantiateState(FSMState state)
        {
            var st = Object.Instantiate(state);
            st.Instantiate();
            return st;
        }

        private void TransitionToState(FSMState state)
        {
            state = InstantiateState(state);
            //if (_currentStateStack.Count > 0) currentState.ExitState(_data);
            //_currentStateStack.Add(state);
            if (_currentState != null)
            {
                _currentState.OnExitPluggers.ForEach( x => (x as IFSMPlugger).Execute(_data));
                _currentState.ExitState(_data);
            }
            _currentState = state;
            _data[STATE_START_TIME] = Time.time;
            currentState.OnStartPluggers.ForEach(x => (x as IFSMPlugger).Execute(_data));
            currentState.StartState(_data);
        }

        public void Transition(FSMState state)
        {
            if (currentState.readyToExit)
            {
                TransitionToState(state);
            }
        }

        public void ForceTransition(FSMState state)
        {
            TransitionToState(state);
        }

        public void SetData(string key, object value)
        {
            _data[key] = value;
        }

        public T GetData<T>(string key)
        {
            if (!_data.ContainsKey(key)) return default(T);
            return (T)_data[key];
        }
    }
}