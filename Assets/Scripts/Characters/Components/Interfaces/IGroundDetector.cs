using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IGroundDetector : IComponent
{
    public bool isGrounded { get; }

    public float fallHeight { get; }
}
