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

    private List<Collider> enteredColliders = new List<Collider>();

    private void OnTriggerEnter(Collider other)
    {
        if(!enteredColliders.Contains(other)) enteredColliders.Add(other);
        triggerEnter.Invoke(other);
    }
    private void OnTriggerExit(Collider other)
    {
        if (enteredColliders.Contains(other)) enteredColliders.Remove(other);
        triggerExit.Invoke(other);
    }
    private void OnTriggerStay(Collider other)
    {
        triggerStay.Invoke(other);
    }

    private void Update()
    {
        for(int i = 0; i < enteredColliders.Count; i++)
        {
            if (!enteredColliders[i] || enteredColliders[i].enabled == false || enteredColliders[i].gameObject.activeInHierarchy == false) 
            {
                OnTriggerExit(enteredColliders[i]);
                break;
            }
        }
    }


}
