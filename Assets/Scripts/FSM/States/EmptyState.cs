using Characters;
using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.FSM.States.Player
{
    [CreateAssetMenu(fileName = "Empty State", menuName = "FSM/Empty State")]
    public class EmptyState : FSMState
    {

        public override bool StartState(Dictionary<string, object> data)
        {
            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
        }
    }
}