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

        public string idleAnimation = "Idle";
        
        [Space]
        public string actionAnimation = "Idle Action 1";


        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _mover = _actor.GetActorComponent<IMover>(0);

            data["idle-start"] = Time.time;
            data["action_delay"] = UnityEngine.Random.Range(10f, 15f);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _mover.Stop();

            string animation = idleAnimation;

            float startTime = (float)data["idle-start"];

            if(Time.time - startTime >= (float)data["action_delay"])
            {
                animation = actionAnimation;
            }

            _actor.GetActorComponent<IAnimator>().Play(0, animation);


        }

        public override bool ExitState(Dictionary<string, object> data)
        {

            return true;
        }
    }
}