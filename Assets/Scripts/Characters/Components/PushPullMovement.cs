using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public class PushPullMovement : MonoBehaviour, IMover
    {
        [SerializeField]
        private Rigidbody _rigidBody;

        [SerializeField] float maxPushSpeed = 1;

        private bool _isEnabled = true;

        private Vector3 _moveDirection;
        private bool _isMoving = false;

        private void Awake()
        {
            _isEnabled = true;
        }

        private void FixedUpdate()
        {
            if (!_isEnabled) return;

            if (_isMoving)
            {
                _rigidBody.AddForce(_moveDirection * _rigidBody.mass, ForceMode.VelocityChange);
                Vector3 v = _rigidBody.velocity;
                v.y = 0;
                v = Vector3.ClampMagnitude(v, maxPushSpeed);
                _rigidBody.velocity = new Vector3(v.x, _rigidBody.velocity.y, v.z);

            }
        }

        public void Enable(bool value)
        {
            _isEnabled = value;
        }

        public void Move(Vector3 direction, float speed)
        {
            _isMoving = true;

            var actorForward = transform.forward;
            actorForward.y = 0;

            var speedFactor = Vector3.Dot(actorForward, new Vector3(direction.x, 0, direction.y));



            _moveDirection = actorForward * speed * speedFactor;
        }

        public void Rotate(Vector3 direction)
        {
            
        }

        public void Stop()
        {
            _isMoving = false;
            _moveDirection = Vector3.zero;
        }
    }
}