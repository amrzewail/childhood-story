using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnPlayerTrigger : OnTrigger
{
    [SerializeField] string targetName = "";

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
        if (other.name == targetName)
        {
            return true;
        }
        return false;
    }
}
