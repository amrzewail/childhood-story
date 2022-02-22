using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformHoldActor : MonoBehaviour 
{
    private List<Transform> _transforms;
    private Vector3 _lastPosition;


    private void Awake()
    {
        _transforms = new List<Transform>();
    }
    private void LateUpdate()
    {
        Vector3 offset = transform.position - _lastPosition;

        foreach(var t in _transforms)
        {
            t.transform.position += offset;
        }

        _lastPosition = transform.position;
    }

    public void TriggerEnter(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            if (!_transforms.Contains(col.transform))
            {
                _transforms.Add(col.transform);
            }
        }
    }
    public void TriggerExit(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            if (_transforms.Contains(col.transform))
            {
                _transforms.Remove(col.transform);
            }
        }
    }

}