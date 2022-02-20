using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IAbilityPerformer : IComponent
{

    public bool CanPerform(int index);

    public void Perform(int index);

    public bool IsComplete();
}
