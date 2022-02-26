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
    public float angle;
    public float distanceMultiplier = 10;
    public float minDistance = 5;
    public float maxDistance = 30;

    private float _distanceBetweenPlayers;

    private Bound clampBound;

    private Vector3 velocity;
    public float smoothTime;

    void Awake()
    {
        targets = new List<ICameraTarget>();
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

        Vector3 off = Vector3.zero;
        off.y = Mathf.Sin(angle * Mathf.Deg2Rad) * Mathf.Clamp(distanceMultiplier * _distanceBetweenPlayers, minDistance, maxDistance);

        Vector3 newPosition = centerPoint + off;

        transform.position = newPosition;
        //transform.position = Vector3.SmoothDamp(transform.position, newPosition, ref velocity, smoothTime);
    }

            
        
    Vector3 GetCenterPoint()
    {
        Vector3 sum = Vector3.zero;
        Vector3 direction = Vector3.zero;
        if (targets.Count == 1)
        {
            return targets[0].transform.position;
        }
        for (int i = 0; i < targets.Count; i++)
        {
            sum += targets[i].transform.position;
            direction = targets[i].transform.position - direction;
        }
        sum /= targets.Count;

        float cos = Mathf.Cos(angle * Mathf.Deg2Rad);

        sum.x += cos * Mathf.Clamp(distanceMultiplier * _distanceBetweenPlayers, minDistance, maxDistance);
        sum.z -= cos * Mathf.Clamp(distanceMultiplier * _distanceBetweenPlayers, minDistance, maxDistance);

        _distanceBetweenPlayers = direction.magnitude;

        return sum;
        //if (targets.Count == 1)
        //{
        //    return targets[0].transform.position;
        //}

        //var bounds = new Bounds(targets[0].transform.position, Vector3.zero);
        //for (int i=0;i < targets.Count; i++)
        //{
        //    bounds.Encapsulate(targets[i].transform.position);
        //}

        //return bounds.center;
    }

    public void SetAngle(float angle)
    {
        transform.eulerAngles = new Vector3(angle, transform.eulerAngles.y, transform.eulerAngles.z);
    }

    public void SetDistance(float distance)
    {
        distanceMultiplier = distance;
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
