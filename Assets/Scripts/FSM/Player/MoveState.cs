using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{
    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+NAME)]
    public class MoveState : FSMState
    {
        public const string NAME = "Move State";

        [SerializeField] string animation = "Run";

        private IActor _actor;
        private IInput _input;
        private IMover _mover;

        public float moveSpeed = 5;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _input = _actor.GetActorComponent<IInput>(0);
            _mover = _actor.GetActorComponent<IMover>(0);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _mover.Move(_input.axis, moveSpeed);

            _actor.GetActorComponent<IAnimator>().Play(0, animation, _input.axis.magnitude, false);
        }
    }
}