using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+ NAME)]
    public class JumpState : FSMState
    {
        public const string NAME = "Jump State";

        private IActor _actor;
        private IMover _mover;
        private IMover _airMover;

        private IInput _input;

        public float moveSpeed = 5;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _mover = _actor.GetActorComponent<IMover>(0);
            _airMover = _actor.GetActorComponent<IMover>(1);

            _input = _actor.GetActorComponent<IInput>(0);

            _mover.Enable(false);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
           _airMover.Move(_input.axis, moveSpeed);
        }

        public override bool ExitState(Dictionary<string, object> data)
        {
            _mover.Enable(true);
            return true;
        }
    }
}