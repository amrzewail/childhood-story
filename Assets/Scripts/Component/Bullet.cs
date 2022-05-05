using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Bullet : MonoBehaviour, IBullet
{

    private Vector3 _direction;
    private bool _isDestroyed = false;
    private float _currentDestroyTime = 0;


    [SerializeField] float speed = 1;
    [SerializeField] float destroyAfter = 5;

    public void Shoot(Vector3 target)
    {
        _direction = target - transform.position;
        //var eulerAngles = transform.eulerAngles;
        //eulerAngles.y = Vector3.Angle(_direction, Vector3.up);
        //transform.eulerAngles = eulerAngles;
    }

    public void Shoot(Transform target)
    {
        Shoot(target.transform.position);
    }

    public void DestroyNow()
    {
        _isDestroyed = true;
        GetComponentsInChildren<Collider>().ToList().ForEach(x => x.enabled = false);
        Destroy(this.gameObject);
    }

    private void Update()
    {
        transform.position += (_direction * speed * TimeManager.gameDeltaTime);

        _currentDestroyTime += TimeManager.gameDeltaTime;

        if(_currentDestroyTime >= destroyAfter)
        {
            Destroy(this.gameObject);
        }
    }
}
