using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrackingBullet : MonoBehaviour, IBullet
{
    [SerializeField] private Transform _target;
    private Quaternion _lookRotation;


    [SerializeField] float _destroyAfter;
    [SerializeField] float _speed = 5;
    [SerializeField] float _angularSpeed = 30;
    [SerializeField] Vector3 _targetOffset = new Vector3(0, 1, 0);

    void Start()
    {
        Destroy(this.gameObject, _destroyAfter);
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

        transform.Translate(Vector3.forward * _speed * TimeManager.gameDeltaTime);

        Vector3 targetPosition = _target.transform.position + _targetOffset;

        Vector3 direction = (targetPosition - transform.position).normalized;

        //create the rotation we need to be in to look at the target
        _lookRotation = Quaternion.LookRotation(direction);

        //rotate us over time according to speed until we are in the required rotation
        transform.rotation = Quaternion.Slerp(transform.rotation, _lookRotation, TimeManager.gameDeltaTime * _angularSpeed);

    }

}
