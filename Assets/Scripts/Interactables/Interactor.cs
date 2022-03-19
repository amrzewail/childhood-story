using System.Collections.Generic;
using UnityEngine;

public class Interactor : MonoBehaviour, IInteractor
{
    private IInteractable availableInteractable = null;

    private IInteractable currentInteractable = null;

    private bool _isInteracting = false;

    private void OnTriggerEnter(Collider other)
    {
        var interactable = other.GetComponent<IInteractable>();
        if (interactable == null) { return; }
        availableInteractable = interactable;
    }
    private void OnTriggerExit(Collider other)
    {
        var interactable = other.GetComponent<IInteractable>();

        if(interactable == null) { return; }

        if (interactable != availableInteractable) { return; }

        availableInteractable = null;
    }

    public IInteractable GetInteractable()
    {
        if (_isInteracting) return currentInteractable;
        return availableInteractable;
    }

    public void Interact(IDictionary<string,object> data)
    {
        if (availableInteractable == null) return;
        _isInteracting = true;
        currentInteractable = availableInteractable;
        currentInteractable.Interact(data);
    }

    public bool IsComplete()
    {
        if (currentInteractable != null)
        {
            _isInteracting = !currentInteractable.IsComplete();
            if (!_isInteracting) currentInteractable = null;
            return !_isInteracting;
        }
        return false;
    }


}
