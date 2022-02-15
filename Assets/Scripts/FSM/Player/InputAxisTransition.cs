using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class InputAxisTransition : FSMTransition
    {
        public const string NAME = "Input Axis Transition";

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInput input = actor.GetActorComponent<IInput>(0);

            if (input.axis.magnitude > 0) return true;
            return false;
        }
    }
}