using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ITargeter : IComponent
{
    bool isThereATarget { get;}
    ITargetable GetTarget();
    List <TargetType> supportedTypes { get; } 
}
