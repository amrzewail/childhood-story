using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IInput : IComponent
{
    public Vector2 axis { get; }
    public Vector2 absAxis { get; }
    public Vector2 aimAxis { get; }
    public bool IsKeyDown(string key);
    public bool IsKeyUp(string key);

}
