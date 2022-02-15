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
                var transition = transitions[i].transition;
                if ((transition.negative ? !transition.IsTrue(data) : transition.IsTrue(data)) && transition.IsProbabilitySuccess())
                {
                    return transitions[i];
                }
            }
            return null;
        }

    }

    [System.Serializable]
    public class Transition
    {
        public FSMState newState;
        public FSMTransition transition;
    }

}