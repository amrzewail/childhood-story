using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IActorIdentity : IComponent
{
    public int characterIdentifier { get; }
}
