using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FiniteStateMachine
{
    [System.Serializable]
    public abstract class FSMState : ScriptableObject
    {
        public string phase { get; protected set; } = "";
        public string animation { get; protected set; } = "";
        public float speed { get; protected set; } = 1;
        public bool mirror { get; protected set; } = false;

        public FSMState inherit;
        [RequireInterface(typeof(IFSMPlugger))] [SerializeField] public List<Object> OnStartPluggers;
        [RequireInterface(typeof(IFSMPlugger))] [SerializeField] public List<Object> OnUpdatePluggers;
        [RequireInterface(typeof(IFSMPlugger))] [SerializeField] public List<Object> OnExitPluggers;

        public Transition[] transitions;

        public bool readyToExit { get; protected set; } = true;

        public virtual void OnEnable()
        {
            phase = "";
            animation = "";
            readyToExit = true;
        }

        public virtual bool StartState(Dictionary<string,object> data)
        {
            return true;
        }

        public abstract void UpdateState(Dictionary<string, object> data);

        public virtual bool ExitState(Dictionary<string, object> data)
        {
            return true;
        }

        public void Instantiate()
        {
            for (int i = 0; i < transitions.Length; i++)
            {
                transitions[i].transition = Object.Instantiate(transitions[i].transition);
            }

            if(inherit)
            {
                inherit = Object.Instantiate(inherit);
                inherit.Instantiate();
            }
        }

        private bool TestTransition(FSMTransition transition, Dictionary<string,object> data)
        {
            return ((transition.negative ? !transition.IsTrue(data) : transition.IsTrue(data)) && transition.IsProbabilitySuccess());
        }

        public virtual Transition CheckTransitions(Dictionary<string,object> data)
        {
            if (inherit)
            {
                var transition = inherit.CheckTransitions(data);
                if (transition != null)
                    return transition;
            }
            for (int i = 0; i < transitions.Length; i++)
            {
                var t = transitions[i];
                if (!TestTransition(t.transition, data))
                {
                    t = null;
                }
                else
                {
                    foreach (var transition in transitions[i].transitions)
                    {
                        if (!TestTransition(transition, data))
                        {
                            t = null;
                            break;
                        }
                    }
                }
                if(t != null) return t;
            }
            return null;
        }

    }

    [System.Serializable]
    public class Transition
    {
        public FSMState newState;
        public FSMTransition transition;
        public List<FSMTransition> transitions;
    }

}