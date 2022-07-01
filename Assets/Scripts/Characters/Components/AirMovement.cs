using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public class AirMovement : MonoBehaviour, IMover
    {
        [SerializeField]
        private Rigidbody _rigidBody;

        [SerializeField] float maxAirSpeed = 5;

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
                v = Vector3.ClampMagnitude(v, maxAirSpeed);
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
            _moveDirection = new Vector3(direction.x, 0, direction.y) * speed;
        }

        public void Rotate(Vector3 direction)
        {
            
        }

        public void Up(float speed)
        {
            
        }
        public void Stop()
        {
            _isMoving = false;
            _moveDirection = Vector3.zero;
        }
    }
}