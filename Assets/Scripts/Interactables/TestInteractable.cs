using Characters;
using System.Collections.Generic;
using UnityEngine;

public class TestInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] private string interactionText = "Interacted";
    public void Interact(IDictionary<string, object> data) {
        
        IActor actor = (IActor)data["actor"];
        actor.transform.position = Vector3.zero;
        Debug.Log(((IActor)data["actor"]).transform.name);

    }

    public bool IsComplete()
    {
        return true;
    }
}
