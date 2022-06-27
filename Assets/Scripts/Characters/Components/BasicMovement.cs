using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BasicMovement : MonoBehaviour, IMover
{
    private bool _isEnabled = true;
    private bool _didDisableGravity = false;
    private Vector3 _direction;
    private Vector3 _rotateDirection;
    private float _lastSpeed;

    [SerializeField] Rigidbody _rigidbody;
    [SerializeField] Collider _collider;




    void Start()
    {

    }

    void FixedUpdate()
    {
        if (_didDisableGravity)
        {
            _rigidbody.useGravity = true;
            _didDisableGravity = false;
        }
        if (!_isEnabled) return;

        RaycastHit hit;
        Physics.Raycast(_collider.transform.position + Vector3.up * 0.5f, Vector3.down, out hit, 0.6f);

        if (hit.transform)
        {
            var slopeRotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
            _direction = slopeRotation * _direction;

            if(slopeRotation.eulerAngles.magnitude > 0.01f)
            {
                _rigidbody.useGravity = false;
                _didDisableGravity = true;
            }
        }

        _rigidbody.velocity = Vector3.MoveTowards(_rigidbody.velocity, _direction, _lastSpeed * 10 * Time.deltaTime);

        if (_rotateDirection.magnitude > 0)
        {
            float angle = -180 * Mathf.Atan2(_rotateDirection.z, _rotateDirection.x) / Mathf.PI + 90;
            if (angle < 0) angle += 360;
            if (!(_rigidbody.transform.eulerAngles.y > angle - 1 && _rigidbody.transform.eulerAngles.y < angle + 1))
            {
                _rigidbody.rotation = Quaternion.RotateTowards(_rigidbody.rotation, Quaternion.Euler(0, angle, 0), 700 * Time.deltaTime);
            }
        }
    }

    public void Enable(bool value)
    {
        _isEnabled = value;
    }

    public void Move(Vector3 direction, float speed)
    {
        direction.z = direction.y;
        direction.y = 0;
        _direction = direction * speed;

        _lastSpeed = speed;
        _rotateDirection = direction;
    }

    public void Rotate(Vector3 direction)
    {
        direction.z = direction.y;
        direction.y = 0;
        _rotateDirection = direction;
    }

    public void Stop()
    {
        _direction = Vector3.zero;// new Vector3(0, _direction.y, 0);\
    }

}
