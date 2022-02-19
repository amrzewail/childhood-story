using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class AbilityCompleteTransition : FSMTransition
    {
        public const string NAME = "Ability Complete Transition";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IAbilityPerformer performer = actor.GetActorComponent<IAbilityPerformer>(0);

            return performer.IsComplete();
        }
    }
}