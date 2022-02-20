using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/"+ NAME)]
    public class AbilityState : FSMState
    {
        public const string NAME = "Ability State";

        private IActor _actor;

        public int abilityIndex = 0;

        public override bool StartState(Dictionary<string, object> data)
        {
            _actor = (IActor)data["actor"];
            _actor.GetActorComponent<IAbilityPerformer>(0).Perform(abilityIndex);

            return true;
        }

        public override void UpdateState(Dictionary<string, object> data)
        {

        }
    }
}