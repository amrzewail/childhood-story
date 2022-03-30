using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Targetable : MonoBehaviour, ITargetable
{
    [SerializeField] TargetType _targetType;
    public TargetType targetType => _targetType;

    public bool isTargetable { get; set; }
}
