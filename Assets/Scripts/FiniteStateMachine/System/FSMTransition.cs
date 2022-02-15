using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FiniteStateMachine {

    public abstract class FSMTransition : ScriptableObject
    {
        public bool negative = false;
        [Range(0f, 1f)]
        public float probability = 1.0f;
        public float probabilityCheckCooldown = 0;


        private float _lastProbabilityCheck { get; set; } = 0;

        public abstract bool IsTrue(Dictionary<string,object> data);

        public virtual void OnEnable()
        {
            _lastProbabilityCheck = -50;
        }

        public bool IsProbabilitySuccess()
        {
            if (Time.time - _lastProbabilityCheck >= probabilityCheckCooldown)
            {
                _lastProbabilityCheck = Time.time;
                return Random.Range(0f, 1f) <= probability;
            }
            return false;
        }
    }
}