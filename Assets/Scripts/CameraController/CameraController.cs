using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour, ICamera
{
    private struct Bound
    {
        public float left;
        public float right;
        public float up;
        public float down;
    }

    public List<ICameraTarget> targets;
    public Vector3 offset;
    public float angle;
    public float boundAngle = 30;

    private Bound clampBound;

    private Vector3 velocity;
    public float smoothTime;

    void Awake()
    {
        targets = new List<ICameraTarget>();
        angle = transform.eulerAngles.x;
    }

    void LateUpdate()
    {
        if (targets.Count == 0)
        {
            return;
        }

        SetAngle(angle);

        Move();
        Zoom();
    }
    void Zoom()
    {
            
    }


    void Move()
    {
        Vector3 centerPoint = GetCenterPoint();

        Vector3 newPosition = centerPoint + offset;

        transform.position = Vector3.SmoothDamp(transform.position, newPosition, ref velocity, smoothTime);
    }

            
        
    Vector3 GetCenterPoint()
    {
        if (targets.Count == 1)
        {
            return targets[0].transform.position;
        }

        var bounds = new Bounds(targets[0].transform.position, Vector3.zero);
        for (int i=0;i < targets.Count; i++)
        {
            bounds.Encapsulate(targets[i].transform.position);
        }

        return bounds.center;
    }

    public void SetAngle(float angle)
    {
        transform.eulerAngles = new Vector3(angle, transform.eulerAngles.y, transform.eulerAngles.z);
    }

    public void SetDistance(float distance)
    {
        offset.y = distance;
    }

    public void AddTarget(ICameraTarget target)
    {
        targets.Add(target);
    }

    public void RemoveTarget(ICameraTarget target)
    {
        targets.Remove(target);
    }
}
