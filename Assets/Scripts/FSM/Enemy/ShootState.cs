using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Enemy
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Enemy/" + NAME)]
    public class ShootState : FSMState
    {
        public const string NAME = "Shoot State";

        private IActor _actor;
        private IMover _mover;
        private ITargeter _targeter;
        

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _mover = _actor.GetActorComponent<IMover>(0);
            _targeter = _actor.GetActorComponent<ITargeter>(0);

            Vector3 direction = _targeter.GetTarget().targetPosition - _actor.transform.position;
            direction.y = direction.z;

            _mover.Rotate(direction);

            var shooter = _actor.GetActorComponent<IShooter>(0);

            shooter.Shoot(shooter.GetOrigin() + _actor.transform.forward);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _mover.Stop();


            Debug.Log("Shooting");
        }
    }
}