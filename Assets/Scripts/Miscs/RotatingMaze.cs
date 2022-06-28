using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.Events;

public class RotatingMaze : MonoBehaviour
{
    [SerializeField] Transform rotator;

    [SerializeField] UnityEvent OnRotation;

    private bool _isRotating = false;

    public void RotateY(float value)
    {
        StartCoroutine(RotateCoroutine(new Vector3(0, value, 0)));
    }
    public void RotateX(float value)
    {
        StartCoroutine(RotateCoroutine(new Vector3(value, 0, 0)));
    }
    public void RotateZ(float value)
    {
        StartCoroutine(RotateCoroutine(new Vector3(0, 0, value)));
    }

    public void RotateToFinal()
    {
        StartCoroutine(RotateToCoroutine(new Vector3(-90, 180, 0)));
    }

    IEnumerator RotateCoroutine(Vector3 euler)
    {
        if (!_isRotating)
        {
            OnRotation?.Invoke();
            _isRotating = true;

            float displacementDuration = 0.35f;
            float rotationDuration = 0.35f;
            Vector3 displacement = new Vector3(0, 4, 0);

            rotator.DOLocalMove(-displacement, displacementDuration);

            yield return new WaitForGameSeconds(displacementDuration);

            rotator.DORotate(euler, rotationDuration, RotateMode.WorldAxisAdd);

            yield return new WaitForGameSeconds(rotationDuration);

            rotator.DOLocalMove(Vector3.zero, displacementDuration);

            _isRotating = false;
        }
    }
    IEnumerator RotateToCoroutine(Vector3 euler)
    {
        if (!_isRotating)
        {
            _isRotating = true;

            float displacementDuration = 0.35f;
            float rotationDuration = 0.35f;
            Vector3 displacement = new Vector3(0, 4, 0);

            rotator.DOLocalMove(-displacement, displacementDuration);

            yield return new WaitForGameSeconds(displacementDuration);

            rotator.DORotate(euler, rotationDuration, RotateMode.Fast);

            yield return new WaitForGameSeconds(rotationDuration);

            rotator.DOLocalMove(Vector3.zero, displacementDuration);

            _isRotating = false;
        }
    }
}
