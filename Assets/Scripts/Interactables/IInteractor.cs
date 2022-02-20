using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IInteractor:IComponent
{
    IInteractable GetInteractable();

    void Interact(IDictionary<string,object> data);

    bool IsComplete();

}