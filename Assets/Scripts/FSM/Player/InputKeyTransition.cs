using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Player
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Player/" + NAME)]
    public class InputKeyTransition : FSMTransition
    {
        public const string NAME = "Input Key Transition";

        [SerializeField] string key;
        [SerializeField] PressType pressType;

        public enum PressType
        {
            Hold,
            Down,
            Up
        }

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            IInput input = actor.GetActorComponent<IInput>(0);

            switch (pressType)
            {
                case PressType.Down: return input.IsKeyDown(key);
            }
            return false;
        }
    }
}