using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+ NAME)]
    public class IdleState : FSMState
    {
        public const string NAME = "Idle State";

        private IActor _actor;
        private IMover _mover;

        public float moveSpeed = 5;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _mover = _actor.GetActorComponent<IMover>(0);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _mover.Stop();
        }
    }
}