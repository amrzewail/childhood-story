using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class InteractionCompleteTransition : FSMTransition
    {
        public const string NAME = "Interaction Complete Transition";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInteractor interactor = actor.GetActorComponent<IInteractor>(0);

            if (interactor.GetInteractable() == null) return true;
            if (interactor.IsComplete()) return true;
            return false;
        }
    }
}