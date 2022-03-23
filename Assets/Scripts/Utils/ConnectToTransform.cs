using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConnectToTransform : MonoBehaviour
{

    public Transform target;

    private Vector3 _localPositionToTarget;
    private Vector3 _targetLastEuler;

    public bool connectPosition = true;
    public bool connectEulerAngles = false;

    private void Start()
    {
        _localPositionToTarget = target.InverseTransformPoint(transform.position);
        _targetLastEuler = target.eulerAngles;
    }

    // Update is called once per frame
    void LateUpdate()
    {
        if (connectPosition)
        {
            transform.position = target.TransformPoint(_localPositionToTarget);
        }

        if (connectEulerAngles)
        {
            var deltaEuler = target.eulerAngles - _targetLastEuler;
            transform.eulerAngles += deltaEuler;
            _targetLastEuler = target.eulerAngles;
        }

    }
}
