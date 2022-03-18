using Characters;
using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = NAME, menuName = "FSM/" + NAME)]
public class DeadTransition : FSMTransition
{
    public const string NAME = "Dead Transition";

    public override bool IsTrue(Dictionary<string, object> data)
    {
        IActor actor = data["actor"] as IActor;
        return actor.GetActorComponent<IActorHealth>(0).IsDead();
    }
}