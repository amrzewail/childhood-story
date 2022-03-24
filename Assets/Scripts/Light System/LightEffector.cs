using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightEffector : MonoBehaviour
{
    public static List<LightEffector> effectors { get; private set; }

    public Light light;
    public float rangeRatio = 1;
    public bool gizmos = false;

    internal void Start()
    {
        if (effectors == null) effectors = new List<LightEffector>();
        if (!effectors.Contains(this))
        {
            effectors.Add(this);
        }
    }

    internal void OnEnable()
    {
        if (effectors == null) return;

        if (!effectors.Contains(this))
        {
            effectors.Add(this);
        }
    }

    internal void OnDisable()
    {
        if (effectors == null) return;
        if (effectors.Contains(this))
        {
            effectors.Remove(this);
        }
    }

    internal void OnDestroy()
    {
        if (effectors.Contains(this))
        {
            effectors.Remove(this);
        }
    }

    internal void Reset()
    {
        light = GetComponent<Light>();
    }

    internal void OnDrawGizmosSelected()
    {
        if (!light) return;
        if (!gizmos) return;
        Gizmos.DrawWireSphere(light.transform.position, light.range * rangeRatio);
    }
}
