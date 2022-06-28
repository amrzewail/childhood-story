using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
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
    public float zoomMultiplier = 1;
    public Vector3 centerOffset;
    public float heightDiffFactor = 1;
    public float zDiffFactor = 1;
    public float xDiffFactor = 1;

    private bool _isEnabled = true;
    private float _distanceBetweenPlayers;

    private Bound clampBound;

    private Vector3 velocity;
    public float smoothTime;

    void Awake()
    {
        targets = new List<ICameraTarget>();
    }

    void FixedUpdate()
    {
        if (targets.Count == 0 || !_isEnabled)
        {
            return;
        }
        Move();
    }

    void LateUpdate()
    {
        if (targets.Count == 0 || !_isEnabled)
        {
            return;
        }

        SetAngle(angle);

        Move();
    }
    public void Zoom(float value)
    {
        zoomMultiplier = 1f / value;
    }


    void Move()
    {
        Vector3 centerPoint = GetCenterPoint();

        //Vector3 off = Vector3.zero;
        //off.y = Mathf.Sin(angle * Mathf.Deg2Rad) * Mathf.Clamp(distanceMultiplier * _distanceBetweenPlayers, minDistance, maxDistance);

        Vector3 newPosition = centerPoint;

        //transform.position = newPosition;
        transform.position = Vector3.SmoothDamp(transform.position, newPosition, ref velocity, smoothTime);
    }

            
    
    Vector3 GetCenterPoint()
    {
        Vector3 result = Vector3.zero;

        Vector3 center = (targets[0].transform.position + targets[1].transform.position) / 2;
        center.y = targets.Max(t => t.transform.position.y);

        _distanceBetweenPlayers = (targets[0].transform.position - targets[1].transform.position).magnitude;
        _distanceBetweenPlayers *= distanceMultiplier;
        _distanceBetweenPlayers = Mathf.Clamp(_distanceBetweenPlayers, minDistance, maxDistance);
        center += -transform.forward * _distanceBetweenPlayers * zoomMultiplier;



        RaycastHit hit;
        Physics.Raycast(transform.position, transform.forward, out hit);

        var orderedList = targets.OrderByDescending(x => x.transform.position.y);
        var yDiff = Mathf.Abs(targets[0].transform.position.y - targets[1].transform.position.y);
        Vector3 highestAndLowestOffset = orderedList.ElementAt(0).transform.position - orderedList.ElementAt(1).transform.position;



        center += centerOffset * Vector3.Distance(transform.position, center) + highestAndLowestOffset * yDiff * heightDiffFactor;

        result = center;
        //Debug.Log(Vector3.Distance(targets[0].transform.position, targets[1].transform.position));

        return result;
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

    public void Enable(bool enable)
    {
        _isEnabled = enable;
    }
}
