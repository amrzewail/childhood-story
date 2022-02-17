using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICamera
{
    public void SetAngle(float angle);
    public void SetDistance(float distance);
    public void AddTarget(ICameraTarget target);
    public void RemoveTarget(ICameraTarget target);
}