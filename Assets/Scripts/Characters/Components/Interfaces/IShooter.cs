using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IShooter : IComponent
{
    void Shoot(Vector3 target);

    void Shoot(Transform target);

    bool CanShoot();

    Vector3 GetOrigin();
}
