using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour, IBullet
{

    private Vector3 _direction;

    [SerializeField] float speed = 1;
    [SerializeField] float destroyAfter = 5;

    public void Shoot(Vector3 target)
    {
        _direction = target - transform.position;
        //var eulerAngles = transform.eulerAngles;
        //eulerAngles.y = Vector3.Angle(_direction, Vector3.up);
        //transform.eulerAngles = eulerAngles;
        Destroy(this.gameObject, destroyAfter);
    }

    public void Shoot(Transform target)
    {
        Shoot(target.transform.position);
    }

    public void DestroyNow()
    {
        Destroy(this.gameObject);
    }

    private void Update()
    {
        transform.position += (_direction * speed * Time.deltaTime);
    }
}
