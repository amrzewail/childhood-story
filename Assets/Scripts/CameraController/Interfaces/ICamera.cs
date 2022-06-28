using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICamera
{
    public Transform transform { get; }
    public void SetAngle(float angle);
    public void SetDistance(float distance);
    public void AddTarget(ICameraTarget target);
    public void RemoveTarget(ICameraTarget target);
    public void Enable(bool enable);

    public void Zoom(float value);
}