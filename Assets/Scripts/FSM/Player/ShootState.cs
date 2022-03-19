using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{
    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+NAME)]
    public class ShootState : FSMState
    {
        public const string NAME = "Shoot State";

        private IActor _actor;
        private IInput _input;
        private IMover _mover; 
        private IAnimator _animator;

        private bool _didShoot = false;

        public string shootAnimation;
        [Range(0, 1)]
        public float shootTime;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _input = _actor.GetActorComponent<IInput>(0);
            _mover = _actor.GetActorComponent<IMover>(0);
            _animator = _actor.GetActorComponent<IAnimator>(0);

            _animator.Play(0, shootAnimation);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _mover.Stop();

            if(!_didShoot && _animator.GetNormalizedTime(0) > shootTime)
            {
                var shooter = _actor.GetActorComponent<IShooter>(0);
                shooter.Shoot(shooter.GetOrigin() + _actor.transform.forward);
                _didShoot = true;
            }
        }
    }
}