using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ILightDetector : IComponent
{
    bool isOnLight { get; }

    bool isActive { get; set; }
}
