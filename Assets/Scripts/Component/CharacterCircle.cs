using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterCircle : MonoBehaviour
{
    [SerializeField] [RequireInterface(typeof(IInput))] Object _input;

    public IInput input => (IInput)_input;

    private void LateUpdate()
    {
        Vector3 eulerAngles = transform.eulerAngles;

        Vector2 axis = input.aimAxis;

        if (axis.magnitude == 0) return;

        float angle = -180 * Mathf.Atan2(axis.y, axis.x) / Mathf.PI + 90;

        eulerAngles.y = angle;

        //Debug.Log($"axis.y:{axis.y} axis.x:{axis.x} angle:{eulerAngles.y}");

        transform.eulerAngles = eulerAngles;
    }
}
