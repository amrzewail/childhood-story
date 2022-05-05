using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+ NAME)]
    public class DeadState : FSMState
    {
        public const string NAME = "Dead State";

        private IActor _actor;


        public string animationName;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _actor.GetActorComponent<IAnimator>(0).Play(0, animationName);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {
            _actor.GetActorComponent<IMover>(0).Stop();
        }
    }
}