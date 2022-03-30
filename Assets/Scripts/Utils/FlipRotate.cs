using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlipRotate : MonoBehaviour
{
    public float rotationStep = 180;
    public float rotationSpeed = 10;

    private float _targetRotation;

    void Start()
    {
        _targetRotation = transform.eulerAngles.y;
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 euler = transform.eulerAngles;

        euler.y = Mathf.MoveTowardsAngle(euler.y, _targetRotation, rotationSpeed * TimeManager.gameDeltaTime);

        transform.eulerAngles = euler;
    }

    public void Flip()
    {
        _targetRotation += rotationStep;
        _targetRotation %= 360;
    }
}
