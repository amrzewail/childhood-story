using FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public interface IActor
    {
        string identifier { get; }

        Transform transform { get; }

        public T GetActorComponent<T>(int index = 0);

        FSM stateMachine { get; set; }

    }
}