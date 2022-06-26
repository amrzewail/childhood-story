using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallLight : MonoBehaviour
{
    [SerializeField] float force = 10;
    [SerializeField] float repulsiveForce = 20;
    [SerializeField] float damageRadius = 1;
    [SerializeField] int damage = 1;

    private int _targetInstanceId = -1;
    private Rigidbody _actorRigidbody;
    private IActor _actor;

    private bool _applyForce = false;

    private void OnTriggerStay(Collider other)
    {
        if(other.gameObject.layer == Layers.CHARACTER)
        {
            if (!_actorRigidbody)
            {
                int? id = other.GetComponent<IActor>()?.GetActorComponent<IActorIdentity>()?.characterIdentifier;

                if (id == 1)
                {
                    _targetInstanceId = other.GetInstanceID();
                    _actor = other.GetComponent<IActor>();
                    _actorRigidbody = other.GetComponentInChildren<Rigidbody>();
                }
            }
            else
            {
                if (other.GetInstanceID() == _targetInstanceId)
                {
                    _applyForce = true;
                }
            }
            
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if(other.GetInstanceID() == _targetInstanceId)
        {
            _applyForce = false;
            _actorRigidbody.AddForce((-transform.position + _actorRigidbody.transform.position) * force, ForceMode.Force);

        }
    }

    private void FixedUpdate()
    {
        if(_applyForce && _actorRigidbody)
        {
            Vector3 direction = (transform.position - _actorRigidbody.transform.position);
            _actorRigidbody.AddForce(direction * force / Mathf.Pow(direction.magnitude, 1), ForceMode.Force);

            if(direction.magnitude < damageRadius)
            {
                _actor.GetActorComponent<IActorHealth>().Damage(damage);
                _actorRigidbody.AddForce(-direction.normalized * repulsiveForce, ForceMode.Impulse);
            }
        }
    }


    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.yellow;

        Gizmos.DrawWireSphere(transform.position, damageRadius);

        Gizmos.color = Color.white;
    }

}
