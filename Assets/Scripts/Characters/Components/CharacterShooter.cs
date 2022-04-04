using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterShooter : MonoBehaviour, IShooter
{
    [SerializeField] Transform shooterTransform;

    [SerializeField] [RequireInterface(typeof(IBullet))] Object _bullet;

    public IBullet bullet => (IBullet)_bullet;

    public bool CanShoot()
    {
        return true;
    }

    public void Shoot(Vector3 target)
    {
        IBullet b = GameObject.Instantiate(bullet.transform.gameObject).GetComponent<IBullet>();
        b.transform.GetComponentInChildren<IDamager>().casterTransform = shooterTransform;
        b.transform.position = transform.position;
        b.transform.eulerAngles = transform.eulerAngles;
        b.Shoot(target);
    }

    public void Shoot(Transform target)
    {
        Shoot(target);
    }

    public Vector3 GetOrigin()
    {
        return transform.position;
    }

    void Update()
    {
        //if (Input.GetMouseButtonDown(0))
        //{
        //    Shoot(transform.position + transform.parent.forward);
        //}
    }
}
