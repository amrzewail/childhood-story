using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class PushPullTransition : FSMTransition
    {
        public const string NAME = "PushPull Transition";

        public string interactKey = "interact";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInput input = actor.GetActorComponent<IInput>(0);
            IPusher pusher = actor.GetActorComponent<IPusher>(0);

            if (pusher.GetPushable() != null && pusher.GetPushable().CanPush() && input.IsKeyDown(interactKey)) return true;
            return false;
        }
    }
}