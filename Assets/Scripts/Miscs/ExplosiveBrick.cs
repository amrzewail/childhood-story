using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExplosiveBrick : MonoBehaviour
{
    private bool _isExploded = false;


    [SerializeField] float radius = 3;
    [SerializeField] Rigidbody[] _targets;

    [SerializeField] float force = 1000;


    public void Explode()
    {

        if (_isExploded) return;

        foreach(var target in _targets)
        {
            target.isKinematic = false;
            target.AddExplosionForce(force, transform.position, radius);

            target.GetComponentInChildren<Collider>().isTrigger = true;
        }

        _isExploded = true;

    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;

        Gizmos.DrawWireSphere(transform.position, radius);

        Gizmos.color = Color.white;
    }
}
