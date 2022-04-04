using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FiniteStateMachine;
using Characters;

namespace FiniteStateMachine.Enemy
{

    [CreateAssetMenu(fileName = NAME, menuName = "FSM/Enemy/" + NAME)]
    public class TargetDistanceTransition : FSMTransition
    {
        public const string NAME = "Target Distance Transition";

        public float distance = 5;
        public Compare compare;

        public enum Compare
        {
            GreaterThan,
            LesserThan,
            EqualTo
        };

        public override bool IsTrue(Dictionary<string, object> data)
        {
            IActor actor = (IActor)data["actor"];
            float distance = (actor.transform.position - actor.GetActorComponent<ITargeter>(0).GetTarget().targetPosition).magnitude;
            switch (compare)
            {
                case Compare.EqualTo:
                    return distance == this.distance;
                case Compare.GreaterThan:
                    return distance > this.distance;
                case Compare.LesserThan:
                    return distance < this.distance;
            }
            return false;
        }
    }
}