using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Characters
{
    public interface IMover : IComponent
    {
        public void Move(Vector3 direction, float speed);
        public void Stop();
        public void Rotate(Vector3 direction);

    }
}