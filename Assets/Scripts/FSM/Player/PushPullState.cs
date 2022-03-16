using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{
    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+NAME)]
    public class PushPullState : FSMState
    {
        public const string NAME = "PushPull State";
    
        private IActor _actor;
        private IInput _input;
        private IMover _mover;
        private IPusher pusher;
        private Vector3 actorForward;
        public float moveSpeed = 5;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _input = _actor.GetActorComponent<IInput>(0);
            _mover = _actor.GetActorComponent<IMover>(2);
            pusher = _actor.GetActorComponent<IPusher>(0);
            actorForward = _actor.transform.forward;
            actorForward.y = actorForward.z;
            pusher.StartPush(data);
            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            var SpeedFactor =  Vector2.Dot(actorForward, _input.axis);
            Debug.Log(SpeedFactor);
            _mover.Move(actorForward, moveSpeed*SpeedFactor);
        }
        public override bool ExitState(Dictionary<string, object> data)
        {
            pusher.StopPush(data);
            return true;
        }
    }
}