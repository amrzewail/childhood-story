using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ITargetable : IComponent
{
    TargetType targetType { get; }
    bool isTargetable { get; set; }

    Vector3 targetPosition { get;}
}

public enum TargetType
{
    Player,
    Enemy
}