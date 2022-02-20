using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OnTrigger : MonoBehaviour
{
    [SerializeField]
    UnityEvent<Collider> triggerEnter;
    [SerializeField]
    UnityEvent<Collider> triggerStay;
    [SerializeField]
    UnityEvent<Collider> triggerExit;

    private void OnTriggerEnter(Collider other)
    {
        triggerEnter.Invoke(other);
    }
    private void OnTriggerExit(Collider other)
    {
        triggerExit.Invoke(other);
    }
    private void OnTriggerStay(Collider other)
    {
        triggerStay.Invoke(other);
    }
}
