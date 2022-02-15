using Characters;
using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.FSM.Transitions
{
    [CreateAssetMenu(fileName = "True Transition", menuName = "FSM/True Transition")]
    public class TrueTransition : FSMTransition
    {
        public override bool IsTrue(Dictionary<string, object> data)
        {
            return true;
        }
    }
}