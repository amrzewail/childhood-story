using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ITargetable : IComponent
{
    TargetType targetType { get; }
    bool isTargetable { get; set; }
}

public enum TargetType
{
    Player,
    Enemy
}