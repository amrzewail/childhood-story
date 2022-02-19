using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class AbilityTransition : FSMTransition
    {
        public const string NAME = "Ability Transition";

        public string abilityKey = "ability";
        public int abilityIndex = 0;

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInput input = actor.GetActorComponent<IInput>(0);
            IAbilityPerformer performer = actor.GetActorComponent<IAbilityPerformer>(0);

            if(input.IsKeyDown(abilityKey) && performer.CanPerform(abilityIndex))
            {
                return true;
            }

            return false;
        }
    }
}