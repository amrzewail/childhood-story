using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class PushPullCompleteTransition : FSMTransition
    {
        public const string NAME = "PushPull Complete Transition";

        public string interactKey = "interact";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInput input = actor.GetActorComponent<IInput>(0);
            IPusher pusher = actor.GetActorComponent<IPusher>(0);

            if (pusher.GetPushable() != null && !pusher.GetPushable().CanPush() && input.IsKeyUp(interactKey)) return true;
            return false;
        }
    }
}