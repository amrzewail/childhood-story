using System.Collections.Generic;

public interface IInteractable
{
    void Interact(IDictionary<string, object> data);

    bool IsComplete();
}
