using System.Collections.Generic;
using UnityEngine;

public class Interactor : MonoBehaviour,IInteractor
{
    private IInteractable currentInteractable = null;
    private void Update()
    {
       
    }
    private void CheckForInteraction()
    {
        if (currentInteractable == null) { return; }

        if (Input.GetKeyDown(KeyCode.E))
        {
            //currentInteractable.Interact(new Dictionary<string, object>() { { "player", "this is player" } }

        }

    }
    private void OnTriggerEnter(Collider other)
    {
        var interactable = other.GetComponent<IInteractable>();
        if(interactable == null){ return; }
        currentInteractable = interactable;
    }
    private void OnTriggerExit(Collider other)
    {
        var interactable = other.GetComponent<IInteractable>();

        if(interactable == null) { return; }

        if (interactable != currentInteractable) { return; }

        currentInteractable = null;
    }

    public IInteractable GetInteractable()
    {
        return currentInteractable;
    }


}
