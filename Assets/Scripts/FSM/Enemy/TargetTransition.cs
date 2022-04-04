using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Enemy
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Enemy/" + NAME)]
    public class TargetTransition : FSMTransition
    {
        public const string NAME = "Target Transition";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            return actor.GetActorComponent<ITargeter>(0).isThereATarget;
        }
    }
}