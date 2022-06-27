using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrackingBullet : MonoBehaviour, IBullet
{
    private static List<TrackingBullet> _bullets = new List<TrackingBullet>();

    [SerializeField] private Transform _target;
    private Quaternion _lookRotation;
    private float _alternateTimer = 0;
    private bool _isChasingTarget = true;
    private Vector3 _randomTarget;

    [SerializeField] float _destroyAfter;
    [SerializeField] float _speed = 5;
    [SerializeField] float _angularSpeed = 30;
    [SerializeField] Vector3 _targetOffset = new Vector3(0, 1, 0);
    [SerializeField] Rigidbody _rigidbody;

    [Header("Random target")]
    [SerializeField] float _alternateTargetInterval = 10;
    [SerializeField] Rect _randomTargetRect;

    void Start()
    {
        _bullets.Add(this);
        _alternateTimer = 0;
        _alternateTargetInterval = _alternateTargetInterval * UnityEngine.Random.Range(0.5f, 1.5f);
        Destroy(this.gameObject, _destroyAfter);
    }

    void OnDestroy()
    {
        _bullets.Remove(this);
    }

    public void InstantDestroy()
    {
        Destroy(this.gameObject);
    }

    public void Shoot(Vector3 target)
    {

    }

    public void Shoot(Transform target)
    {
        _target = target;

        transform.LookAt(target);
    }



    void Update()
    {
        if (!_target) return;

        _rigidbody.velocity = (transform.forward * _speed * TimeManager.gameSpeed);

        Vector3 targetPosition = _target.position + _targetOffset;

        if (!_isChasingTarget)
        {
            targetPosition = _randomTarget;
        }

        Vector3 direction = (targetPosition - transform.position).normalized;

        //create the rotation we need to be in to look at the target
        _lookRotation = Quaternion.LookRotation(direction);

        //rotate us over time according to speed until we are in the required rotation
        transform.rotation = Quaternion.Slerp(transform.rotation, _lookRotation, TimeManager.gameDeltaTime * _angularSpeed * Vector3.Distance(transform.position, targetPosition) / 10f);

        Vector3 euler = transform.eulerAngles;
        euler.x = euler.z = 0;

        _alternateTimer += Time.deltaTime;

        if(_alternateTimer > _alternateTargetInterval)
        {
            _isChasingTarget = !_isChasingTarget;
            _alternateTimer = 0;
            
            _randomTarget = new Vector3(_randomTargetRect.x, transform.position.y, _randomTargetRect.y) + 
                new Vector3(Random.Range(-_randomTargetRect.width, _randomTargetRect.width), 0, Random.Range(-_randomTargetRect.height, _randomTargetRect.height));
        }

    }

}
