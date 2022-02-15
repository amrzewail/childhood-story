using ProjectSigma.Scripts.FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public interface IActor
    {
        Transform transform { get; }

        FSM stateMachine { get; set; }

    }
}