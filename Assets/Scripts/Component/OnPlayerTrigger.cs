using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnPlayerTrigger : OnTrigger
{
    private void OnTriggerEnter(Collider other)
    {
        if (!IsPlayer(other)) return;

        if (!enteredColliders.Contains(other)) enteredColliders.Add(other);

        triggerEnter.Invoke(other);
    }
    private void OnTriggerExit(Collider other)
    {
        if (!IsPlayer(other)) return;

        if (enteredColliders.Contains(other)) enteredColliders.Remove(other);
        triggerExit.Invoke(other);
    }
    private void OnTriggerStay(Collider other)
    {
        if (!IsPlayer(other)) return;

        triggerStay.Invoke(other);
    }

    private bool IsPlayer(Collider other)
    {
        IActor actor = null;
        if ((actor = other.GetComponent<IActor>()) != null) 
        {
            if(actor.GetActorComponent<IActorIdentity>().characterIdentifier < 2)
            {
                return true;
            }
        }
        return false;
    }
}
