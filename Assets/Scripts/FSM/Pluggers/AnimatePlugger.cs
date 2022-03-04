using Characters;
using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = NAME, menuName = "FSM/Pluggers/" + NAME)]
public class AnimatePlugger : ScriptableObject, IFSMPlugger
{
    public const string NAME = "Animate Plugger";

    public string animationName;
    public void Execute(Dictionary<string, object> data)
    {

        IActor actor = (IActor)data["actor"];
        IAnimator animator = actor.GetActorComponent<IAnimator>(0);

        animator.Play(0, animationName);

    }
}
