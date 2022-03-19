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
        private IAnimator animator;

        public float moveSpeed = 5;

        public string pushPoseAnimation = "Push Pose";
        public string pushAnimation = "Push";
        public string pullAnimation = "Pull";

        private string _lastAnimation;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _input = _actor.GetActorComponent<IInput>(0);
            _actor.GetActorComponent<IMover>(0).Enable(false);
            _mover = _actor.GetActorComponent<IMover>(2);
            pusher = _actor.GetActorComponent<IPusher>(0);
            animator = _actor.GetActorComponent<IAnimator>(0);

            pusher.StartPush(data);
            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            if (pusher.GetPushable().CanMove())
            {
                float dot = Vector3.Dot(_actor.transform.forward, new Vector3(_input.axis.x, 0, _input.axis.y));
                if(dot > 0)
                {
                    animator.Play(0, pushAnimation);
                    _lastAnimation = pushAnimation;
                    animator.Unpause();
                }else if (dot < 0)
                {
                    animator.Play(0, pullAnimation);
                    _lastAnimation = pullAnimation;
                    animator.Unpause();
                }
                else
                {
                    if (string.IsNullOrEmpty(_lastAnimation))
                    {
                        animator.Play(0, pushPoseAnimation);
                    }
                    else
                    {
                        animator.Pause();
                    }
                }

                _mover.Move(_input.axis, moveSpeed);

            }
        }
        public override bool ExitState(Dictionary<string, object> data)
        {
            _actor.GetActorComponent<IMover>(0).Enable(true);
            animator.Unpause();
            pusher.StopPush(data);
            _mover.Stop();
            return true;
        }
    }
}