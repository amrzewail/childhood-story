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
    public Vector3 centerOffset;
    public float heightDiffFactor = 1;
    public float zDiffFactor = 1;
    public float xDiffFactor = 1;

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
        Move();
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

        //Vector3 off = Vector3.zero;
        //off.y = Mathf.Sin(angle * Mathf.Deg2Rad) * Mathf.Clamp(distanceMultiplier * _distanceBetweenPlayers, minDistance, maxDistance);

        Vector3 newPosition = centerPoint;

        transform.position = newPosition;
        //transform.position = Vector3.SmoothDamp(transform.position, newPosition, ref velocity, smoothTime);
    }

            
    
    Vector3 GetCenterPoint()
    {
        Vector3 result = Vector3.zero;

        Vector3 center = (targets[0].transform.position + targets[1].transform.position) / 2;
        center.y = 0;

        _distanceBetweenPlayers = (targets[0].transform.position - targets[1].transform.position).magnitude;
        _distanceBetweenPlayers *= distanceMultiplier;
        _distanceBetweenPlayers = Mathf.Clamp(_distanceBetweenPlayers, minDistance, maxDistance);
        center += -transform.forward * _distanceBetweenPlayers;



        RaycastHit hit;
        Physics.Raycast(transform.position, transform.forward, out hit);

        var orderedList = targets.OrderByDescending(x => x.transform.position.y);
        var yDiff = Mathf.Abs(targets[0].transform.position.y - targets[1].transform.position.y);
        Vector3 highestAndLowestOffset = orderedList.ElementAt(0).transform.position - orderedList.ElementAt(1).transform.position;



        center += centerOffset * Vector3.Distance(transform.position, center) + highestAndLowestOffset * yDiff * heightDiffFactor;

        result = center;
        Debug.Log(Vector3.Distance(targets[0].transform.position, targets[1].transform.position));

        return result;
    }

    Vector3 GetCenterPointF()
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

        var orderedList = targets.OrderByDescending(x => x.transform.position.y);
        var orderedListZ = targets.OrderBy(x => x.transform.position.z);

        Vector3 highestAndLowestOffset = orderedList.ElementAt(0).transform.position - orderedList.ElementAt(1).transform.position;
        Vector3 forwardAndBackOffset = orderedListZ.ElementAt(1).transform.position - orderedListZ.ElementAt(0).transform.position;

        ICameraTarget backTarget = orderedListZ.ElementAt(0);

        highestAndLowestOffset.y = 0;

        //highestAndLowestOffset.x = highestAndLowestOffset.x > 0 ? 0 : highestAndLowestOffset.x;

        //highestAndLowestOffset.x *= xDiffFactor * yDiff;
        //highestAndLowestOffset.z = forwardAndBackOffset.z * zDiffFactor ;
        //highestAndLowestOffset.z = highestAndLowestOffset.z > 0 ? 0 : highestAndLowestOffset.z;

        //highestAndLowestOffset.z = Mathf.Clamp(hieg)

        //Debug.Log(transform.position - backTarget.transform.position);

        Vector3 vec = backTarget.transform.position - transform.position;
        Debug.Log(Vector3.Distance(targets[0].transform.position, targets[1].transform.position));


        Vector3 result = sum + centerOffset * Vector3.Distance(transform.position, sum);

        //Vector3 result = sum + centerOffset * Vector3.Distance(transform.position, sum) + highestAndLowestOffset * yDiff * heightDiffFactor;

        //if(result.z > orderedListZ.ElementAt(0).transform.position.z - 1)
        //{
        //    result.z = orderedListZ.ElementAt(0).transform.position.z - 1;
        //}

        return result;
        //if (targ ets.Count == 1)
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
