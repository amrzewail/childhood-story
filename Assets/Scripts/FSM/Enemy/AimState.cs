using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Enemy
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Enemy/" + NAME)]
    public class AimState : FSMState
    {
        public const string NAME = "Aim State";

        private IActor _actor;
        private IMover _mover;
        private ITargeter _targeter;
        

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _mover = _actor.GetActorComponent<IMover>(0);
            _targeter = _actor.GetActorComponent<ITargeter>(0);

            _mover.Stop();


            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _mover.Stop();

            Vector3 direction = _targeter.GetTarget().targetPosition - _actor.transform.position;
            direction.y = direction.z;

            _mover.Rotate(direction);
        }
    }
}