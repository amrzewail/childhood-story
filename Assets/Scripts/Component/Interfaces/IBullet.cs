using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IBullet
{

    Transform transform { get; }

    void Shoot(Vector3 target);

    void Shoot(Transform target);
}
