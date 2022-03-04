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
        private IAnimator _animator;
        private IInput _input;

        private Vector3 _lastPosition;

        public float moveSpeed = 5;

        public string jumpAnimationName;
        public string fallAnimationName;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _mover = _actor.GetActorComponent<IMover>(0);
            _airMover = _actor.GetActorComponent<IMover>(1);
            _animator = _actor.GetActorComponent<IAnimator>(0);
            _input = _actor.GetActorComponent<IInput>(0);

            _mover.Enable(false);

            _lastPosition = _actor.transform.position;

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _airMover.Move(_input.axis, moveSpeed);

            var deltaPosition = _actor.transform.position - _lastPosition;
            if(deltaPosition.y > 0)
            {
                _animator.Play(0, jumpAnimationName);
            }else if (deltaPosition.y < 0)
            {
                _animator.Play(0, fallAnimationName);
            }
            _lastPosition = _actor.transform.position;
        }

        public override bool ExitState(Dictionary<string, object> data)
        {
            _mover.Enable(true);
            _airMover.Stop();
            return true;
        }
    }
}