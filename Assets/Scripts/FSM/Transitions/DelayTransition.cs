using Characters;
using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = NAME, menuName = "FSM/" + NAME)]
public class DelayTransition : FSMTransition
{
    public const string NAME = "Delay Transition";

    public float delay;

    public override bool IsTrue(Dictionary<string, object> data)
    {
        float stateStartTime = ((float)data[FSM.STATE_START_TIME]);

        return (Time.time - stateStartTime) >= delay;
    }
}