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

    private Transform _directioner;
    private Vector3 _position;
    private bool _didAssignPosition = false;

    [SerializeField] Rigidbody _rigidbody;
    [SerializeField] Collider _collider;
    [SerializeField] LayerMask _groundLayers;



    void Start()
    {
        _directioner = new GameObject("Directioner").transform;
        _directioner.SetParent(this.transform);
        _directioner.localPosition = Vector3.zero;
    }

    void FixedUpdate()
    {
        _rigidbody.useGravity = true;
        if (!_isEnabled) return;

        _position = _rigidbody.transform.position;

        RaycastHit hit;
        Ray downRay = new Ray(_rigidbody.transform.position + Vector3.up, Vector3.down);

        if (Physics.SphereCast(downRay, 0.25f, out hit, 1.5f, ~LayerMask.GetMask(new string[] {"TransparentShadow"}), queryTriggerInteraction: QueryTriggerInteraction.Ignore))
        {
            if (hit.transform.gameObject.layer == Layers.GROUND)
            {
                //_directioner.position = hit.point;
                _directioner.up = hit.normal;

                if (Vector3.Dot(_directioner.up, Vector3.up) < 0.9f)
                {
                    if (_direction.magnitude <= 0.01f)
                    {
                        _rigidbody.useGravity = false;
                    }
                    _position.y = hit.point.y;

                }
                else
                {
                    _position.y = hit.point.y;
                    if (transform.parent.name == "Light")
                    {
                        Debug.Log($"y:{_position.y} hit:{hit.transform.name}");
                    }
                }
            }
        }

        _rigidbody.transform.position = _position;


        Vector3 dir = _directioner.forward * _direction.z;
        dir += _directioner.right * _direction.x;
        dir += Vector3.up * _direction.y;

        Vector3 velocity = _rigidbody.velocity;
        velocity.x = Mathf.MoveTowards(velocity.x, dir.x, _lastSpeed * 10 * Time.deltaTime);
        velocity.z = Mathf.MoveTowards(velocity.z, dir.z, _lastSpeed * 10 * Time.deltaTime);
        velocity.y = dir.y;
        _rigidbody.velocity = velocity;


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

    public void Up(float speed)
    {
        _direction.y = speed;
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
