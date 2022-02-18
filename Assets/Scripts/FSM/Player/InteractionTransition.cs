using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class InteractionTransition : FSMTransition
    {
        public const string NAME = "Interaction Transition";

        public string interactKey = "interact";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInput input = actor.GetActorComponent<IInput>(0);
            IInteractor interactor = actor.GetActorComponent<IInteractor>(0);

            if (interactor.GetInteractable() != null && interactor.GetInteractable().CanInteract() && input.IsKeyDown(interactKey)) return true;
            return false;
        }
    }
}