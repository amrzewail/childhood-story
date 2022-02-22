using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class GroundedTransition : FSMTransition
    {
        public const string NAME = "Grounded Transition";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IGroundDetector ground = actor.GetActorComponent<IGroundDetector>(0);

            if (ground.isGrounded) return true;
            return false;
        }
    }
}