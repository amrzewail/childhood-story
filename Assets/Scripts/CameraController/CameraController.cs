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

    void Start()
    {
        targets = new List<ICameraTarget>();
        angle = transform.eulerAngles.x;
    }

    /*  void FixedUpdateF()
      {
          Vector3 start = transform.position;
          Vector3 right = RightEnd(start);
          Vector3 left = LeftEnd(start);
          Vector3 up = UpEnd(start);
          Vector3 down = DownEnd(start);
          RaycastHit hit;
          if(Physics.Raycast(start, right - start, out hit, 1000))
          {
              clampBound.right = hit.point.x;
          }
          if (Physics.Raycast(start, left - start, out hit, 1000))
          {
              clampBound.left = hit.point.x;
          }
          if (Physics.Raycast(start, up - start, out hit, 1000))
          {
              clampBound.up = hit.point.z;
          }
          if (Physics.Raycast(start, down - start, out hit, 1000))
          {
              clampBound.down = hit.point.z;
          }
      }



      void OnDrawGizmos()
      {
          Gizmos.color = Color.red;

          Vector3 start = transform.position;


          Gizmos.DrawLine(start, RightEnd(start) + (RightEnd(start) - start) * 1000);
          Gizmos.DrawLine(start, UpEnd(start) + (UpEnd(start) - start) * 1000);
          Gizmos.DrawLine(start, DownEnd(start) + (DownEnd(start) - start) * 1000);
          Gizmos.DrawLine(start, LeftEnd(start) + (LeftEnd(start) - start) * 1000);

          Gizmos.color = Color.white;
      }

      private Vector3 RightEnd(Vector3 start)
      {
          Vector3 end = start;
          float y = Mathf.Sin(boundAngle * Mathf.PI / 180f);
          float x = Mathf.Cos(boundAngle * Mathf.PI / 180f);

          end += transform.right * x;
          end += transform.forward * y;
          return end;
      }
      private Vector3 UpEnd(Vector3 start)
      {
          Vector3 end = start;
          float y = Mathf.Sin(boundAngle * Mathf.PI / 180f);
          float x = Mathf.Cos(boundAngle * Mathf.PI / 180f);

          end += transform.up * y;
          end += transform.forward * x;
          return end;
      }
      private Vector3 DownEnd(Vector3 start)
      {
          Vector3 end = start;
          float y = Mathf.Sin(boundAngle * Mathf.PI / 180f);
          float x = Mathf.Cos(boundAngle * Mathf.PI / 180f);

          end -= transform.up * y;
          end += transform.forward * x;
          return end;
      }
      private Vector3 LeftEnd(Vector3 start)
      {
          Vector3 end = start;
          float y = Mathf.Sin(boundAngle * Mathf.PI / 180f);
          float x = Mathf.Cos(boundAngle * Mathf.PI / 180f);

          end -= transform.right * x;
          end += transform.forward * y;
          return end;
      }
    */


    void LateUpdate()
    {
        if (targets.Count == 0)
        {
            return;
        }

        SetAngle(angle);

        Move();
        Zoom();

        //foreach (var p in targets)
        //{
        //    float x = Mathf.Clamp(p.transform.position.x, clampBound.left, clampBound.right);
        //    float z = Mathf.Clamp(p.transform.position.z, clampBound.down, clampBound.up);
        //    p.transform.position = new Vector3(x, p.transform.position.y, z);
        //}


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
