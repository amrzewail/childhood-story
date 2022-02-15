using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public interface IActor
    {
        Transform transform { get; }

        public T GetActorComponent<T>(int index);

        FSM stateMachine { get; set; }

    }
}