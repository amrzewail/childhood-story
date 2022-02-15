using ProjectSigma.Scripts.FiniteStateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public class Actor : MonoBehaviour, IActor
    {


        public FSM stateMachine { get => _stateMachine;  set { _stateMachine = value; } }

        [SerializeField]
        protected FSM _stateMachine;

        private void Awake()
        {

            _stateMachine.Awake();
            _stateMachine.SetData("actor", this);

        }

        private void Start()
        {
            _stateMachine.Start();

        }

        private void Update()
        {
            _stateMachine.Update();

        }

    }
}