using FiniteStateMachine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Characters
{

    public class Actor : MonoBehaviour, IActor
    {
        public FSM stateMachine { get => _stateMachine;  set { _stateMachine = value; } }

        [SerializeField]
        protected FSM _stateMachine;

        private List<IComponent> _components;

        private Dictionary<Type, List<IComponent>> _componentDict;


        private void Awake()
        {
            _components = new List<IComponent>();
            _components = GetComponentsInChildren<IComponent>().ToList();
            _componentDict = new Dictionary<Type, List<IComponent>>();

            for (int i = 0; i < _components.Count; i++)
            {
                var interfaces = ((object)_components[i]).GetType().GetInterfaces();
                foreach (var f in interfaces)
                {
                    Type t = f;

                    if (!_componentDict.ContainsKey(t))
                    {
                        _componentDict[t] = new List<IComponent>();
                    }
                    _componentDict[t].Add(_components[i]);
                }

            }
            

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

        public T GetActorComponent<T>(int index)
        {
            if (!_componentDict.ContainsKey(typeof(T))) return default(T);
            return (T)_componentDict[typeof(T)][index];
        }

    }
}