using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Abdelrahman.Cameras
{

    public class CameraController : MonoBehaviour
    {
        public List<Transform> targets;
        public Vector3 offset;
        
        private Vector3 velocity;
        public float smoothTime;

        void LateUpdate()
        {
            if (targets.Count == 0)
            {
                return;
            }
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
                return targets[0].position;
            }

            var bounds = new Bounds(targets[0].position, Vector3.zero);
            for (int i=0;i < targets.Count; i++)
            {
                bounds.Encapsulate(targets[i].position);
            }

            return bounds.center;
        }

    }
}
