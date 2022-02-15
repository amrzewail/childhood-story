using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProjectSigma.Scripts.FiniteStateMachine
{
    public class FiniteStateMachine : MonoBehaviour
    {
        [SerializeField] private FSM finiteStateMachine;

        private void Awake()
        {
            finiteStateMachine.Awake();
        }

        private void Update()
        {
            finiteStateMachine.Update();
        }
    }
}