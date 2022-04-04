using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
public class PathFindingMover : MonoBehaviour,IMover
{
    public NavMeshAgent agent;
    public Rigidbody _rigidBody;
    public void Enable(bool value)
    {
        agent.enabled = value;
    }

    public void Move(Vector3 position, float speed)
    {
        Debug.Log("Agent Move");
        agent.isStopped = false;
        agent.speed = speed;
        agent.SetDestination(position);
    }

    public void Rotate(Vector3 direction)
    {
        float angle = -180 * Mathf.Atan2(direction.y, direction.x) / Mathf.PI + 90;
        _rigidBody.rotation = Quaternion.RotateTowards(_rigidBody.rotation, Quaternion.Euler(0, angle, 0), 700 * Time.deltaTime);
    }

    public void Stop()
    {
        Debug.Log("Agent Stop");

        agent.isStopped = true;
    }

    // Update is called once per frame
    void Update()
    {
      
    }
}
