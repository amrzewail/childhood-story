using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Characters
{
    public class GroundDetection : MonoBehaviour, IGroundDetector
    {
        public bool isGrounded { get; private set; } = false;
        public float fallHeight { get; private set; }

        [SerializeField]
        private LayerMask _groundLayer;
        [SerializeField]
        private float _extraDistance = 0;
        [SerializeField] float _sphereRadius = 0.25f;
        private float _lastGroundHeight = 0;

        [SerializeField] UnityEvent OnGrounded;
        [SerializeField] UnityEvent OnUnGrounded;

        private void Start()
        {
            isGrounded = Physics.SphereCast(transform.position + Vector3.up * 0.5f, _sphereRadius, Vector3.down, out _, 0.6f + _extraDistance, _groundLayer, QueryTriggerInteraction.Ignore);
            if (isGrounded) OnGrounded?.Invoke();
            if (!isGrounded) OnUnGrounded?.Invoke();
        }

        private void FixedUpdate()
        {
            RaycastHit hit;
            bool lastGrounded = isGrounded;
            isGrounded = Physics.SphereCast(transform.position + Vector3.up * 0.5f, _sphereRadius, Vector3.down, out hit, 0.6f + _extraDistance, _groundLayer, QueryTriggerInteraction.Ignore);
            if (isGrounded) _lastGroundHeight = transform.position.y;
            else fallHeight = _lastGroundHeight - transform.position.y;

            if(!lastGrounded && isGrounded)
            {
                OnGrounded?.Invoke();
            }else if(lastGrounded && !isGrounded)
            {
                OnUnGrounded?.Invoke();
            }
        }

        private void OnDrawGizmos()
        {
            Gizmos.DrawLine(transform.position + Vector3.up * 0.5f, transform.position + Vector3.up * 0.5f + Vector3.down * (0.6f + _extraDistance));
        }
    }
}