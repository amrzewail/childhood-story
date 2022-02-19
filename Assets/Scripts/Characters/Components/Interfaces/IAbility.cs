using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IAbility
{
    bool CanPerform();

    bool IsComplete();

    void Perform();
}
