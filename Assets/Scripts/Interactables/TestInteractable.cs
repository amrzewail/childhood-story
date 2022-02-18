using System.Collections.Generic;
using UnityEngine;

public class TestInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] private string interactionText = "Interacted";
    public void Interact(IDictionary<string, object> data) => Debug.Log(data["player"]);
}
