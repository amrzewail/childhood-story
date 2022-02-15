using Characters;
using ProjectSigma.Scripts.FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.FSM.States.Player
{
    [CreateAssetMenu(fileName = "Linker State", menuName = "FSM/Linker State")]
    public class LinkerState : FSMState
    {
        [SerializeField] FSMState _targetState;

        public override bool StartState(Dictionary<string, object> data)
        {
            return _targetState.StartState(data);
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _targetState.UpdateState(data);
        }

        public override bool ExitState(Dictionary<string, object> data)
        {
            return _targetState.ExitState(data);
        }

        public override Transition CheckTransitions(Dictionary<string, object> data)
        {
            return _targetState.CheckTransitions(data);
        }
    }
}