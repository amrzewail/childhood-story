using Characters;
using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = NAME, menuName = "FSM/" + NAME)]
public class AnimationFinishedTransition : FSMTransition
{
    public const string NAME = "Animation Finished Transition";

    [SerializeField] int _layerIndex = 0;

    public override bool IsTrue(Dictionary<string, object> data)
    {
        IActor actor = data["actor"] as IActor;
        return actor.GetActorComponent<IAnimator>(0).IsAnimationFinished(_layerIndex);
    }
}