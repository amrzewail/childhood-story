using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IDamager
{
    Transform casterTransform { get; set; }
    Transform transform { get; }
}
