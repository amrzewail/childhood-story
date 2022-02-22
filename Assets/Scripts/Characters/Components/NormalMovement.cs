using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public class NormalMovement : MonoBehaviour, IMover
    {
        [SerializeField]
        private Rigidbody _rigidBody;
        [SerializeField]
        private Collider _collider;

        [SerializeField]
        private LayerMask _groundLayerMask;
        [SerializeField]
        private float _friction = 10;
        [SerializeField]
        private float _stopFriction = 10;
        [SerializeField]
        private float _climbableHeight = 0.5f;
        [SerializeField]
        private float _climbableDetectDistance = 0.1f;


        private bool _move;
        private bool _rotate;
        private bool _isEnabled = false;
        private float _speed;
        private float _colliderRadius;
        private Vector2 _moveAxis;
        private Vector2 _rotateAxis;
        private Vector3 _change;

        private float _deltaTime = 0;
        private float _lastDeltaTime = 0;

        protected void Awake()
        {
            if (_collider is CapsuleCollider) _colliderRadius = ((CapsuleCollider)_collider).radius;
            _isEnabled = true;
        }

        public void Move(Vector3 direction, float speed)
        {
            if (!_rigidBody)
                return;
            _moveAxis = direction;
            _rotateAxis = direction;
            _move = true;
            _rotate = true;
            _speed = speed;

            //Debug.Log($"Update:: Move");
        }

        public void Stop()
        {
            if (!_rigidBody)
                return;


            _move = false;

            //_rotate = false;
        }

        public void Enable(bool value)
        {
            _isEnabled = value;
        }

        public void StopInstant()
        {
            if (!_rigidBody)
                return;
            _move = false;
            _rigidBody.velocity = Vector3.zero;
        }

        public void StopRotation()
        {
            _rotate = false;
        }

        public void Rotate(Vector3 direction)
        {
            if (!_rigidBody)
                return;
            _rotateAxis = direction;
            _rotate = true;
        }
        public float GetCurrentSpeed()
        {
            return _rigidBody.velocity.magnitude;
        }

        private void Update()
        {
            _deltaTime = Time.deltaTime;
        }

        private int _count = 0;

        protected void FixedUpdate()
        {
            if (!_isEnabled) return;

            if(_lastDeltaTime != _deltaTime)
            {
                _count = 0;
                _lastDeltaTime = _deltaTime;
            }
            int times = Mathf.CeilToInt(_deltaTime / Time.fixedDeltaTime);
            //Debug.Log($"time:{_time} fixed:{_fixedTime} delta:{_fixedTime - _time} times:{Mathf.CeilToInt((_fixedTime - _time) / Time.fixedDeltaTime)} times2:{Mathf.CeilToInt(_deltaTime / Time.fixedDeltaTime)} mod:{(_deltaTime % Time.fixedDeltaTime) / Time.fixedDeltaTime}");
            bool climbingStairs = false;
            if (_move)
            {
                var layerMask = _groundLayerMask;
                RaycastHit hit;
                Physics.Raycast(_collider.transform.position + Vector3.up * 0.5f, Vector3.down, out hit, 0.6f, layerMask);


                float magnitude = Mathf.Clamp(_moveAxis.magnitude, 0, 1);

                var velocity = _rigidBody.velocity;
                float axisY = 0;
                if (!hit.transform)
                    velocity.y = 0;
                else
                    axisY = Mathf.Tan(Mathf.Deg2Rad * (Vector3.Angle(new Vector3(_moveAxis.x, 0, _moveAxis.y), hit.normal) - 90)) * _moveAxis.magnitude;

                Vector3 targetVelocity = new Vector3(_moveAxis.x, axisY, _moveAxis.y).normalized * magnitude * _speed;
                RaycastHit hitClimbable;
                float radius = _colliderRadius;
                Vector3 direction = new Vector3(_moveAxis.x, 0, _moveAxis.y).normalized;
                Vector3 stairRayOrigin = _collider.transform.position + Vector3.up * (_climbableHeight + radius) + direction * 0.1f;
                if (Physics.SphereCast(stairRayOrigin, radius, Vector3.down, out hitClimbable, _climbableHeight, layerMask))
                {
                    //Debug.Log($"{hitClimbable.transform.name} {(hitClimbable.point.y - transform.position.y)}");
                    _rigidBody.AddForce(Vector3.up * (hitClimbable.point.y - _rigidBody.transform.position.y) * 8 * _rigidBody.mass, ForceMode.Impulse);
                    climbingStairs = true;
                }
                //velocity.y = Mathf.Clamp(velocity.y, -_speed, _speed);
                _change = targetVelocity - velocity;
                _change.y = 0;
                _rigidBody.AddForce(_change * _friction * _rigidBody.mass, ForceMode.Force);
                _count++;
                if (_count >= times)
                {
                    _move = false;
                    _count = 0;
                }

                targetVelocity = new Vector3(_rigidBody.velocity.x, 0, _rigidBody.velocity.z);
                targetVelocity = Vector3.ClampMagnitude(targetVelocity, _speed);
                targetVelocity.y = _rigidBody.velocity.y;
                _rigidBody.velocity = targetVelocity;
            }
            else
            {
                var velocity = _rigidBody.velocity;

                Vector3 targetVelocity = Vector3.zero;
                targetVelocity.y = velocity.y;
                //velocity.y = Mathf.Clamp(velocity.y, -_speed, _speed);

                _change = targetVelocity - velocity;
                _rigidBody.AddForce(_change * _stopFriction * _rigidBody.mass, ForceMode.Force);

            }

            if (_rotate)
            {
                if (_rotateAxis.x != 0 || _rotateAxis.y != 0)
                {
                    float angle = -180 * Mathf.Atan2(_rotateAxis.y, _rotateAxis.x) / Mathf.PI + 90;
                    _rigidBody.rotation = Quaternion.RotateTowards(_rigidBody.rotation, Quaternion.Euler(0, angle, 0), 700 * Time.deltaTime);
                    if (angle < 0) angle += 360;
                    if (_rigidBody.transform.eulerAngles.y > angle - 1 && _rigidBody.transform.eulerAngles.y < angle + 1) _rotate = false;
                }
                else
                {
                    _rotate = false;
                }
            }
            if (!climbingStairs)
            {
                StickToGround();
            }
        }

        private void StickToGround()
        {
            RaycastHit hitInfo;
            if (Physics.SphereCast(_collider.transform.position, _colliderRadius, Vector3.down, out hitInfo, _colliderRadius * 0.25f, _groundLayerMask, QueryTriggerInteraction.Ignore))
            {
                if (Mathf.Abs(Vector3.Angle(hitInfo.normal, Vector3.up)) < 85f)
                {
                    _rigidBody.velocity = Vector3.ProjectOnPlane(_rigidBody.velocity, hitInfo.normal);
                }
            }

        }

        private void OnGUI()
        {
            
        }
    }
}