using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;



public class PlayerSystemInput : MonoBehaviour, IInput
{
    [SerializeField] int inputIndex;
    public Vector2 axis { get; private set; }

    public Vector2 absAxis { get; private set; }

    private bool _isInteract = false;


    internal void Start()
    {
        InputEvents.instance.OnMove += MoveCallback;
        InputEvents.instance.OnInteract += InteractCallback;
    }
    internal void LateUpdate()
    {
        _isInteract = false;
    }


    private void MoveCallback(int index, Vector2 a)
    {
        if(index == inputIndex)
        {
            axis = a;
            float radians = -Camera.main.transform.eulerAngles.y * Mathf.PI / 180;
            float cos = Mathf.Cos(radians), sin = Mathf.Sin(radians);
            var ax = axis;
            ax.x = cos * axis.x - sin * axis.y;
            ax.y = cos * axis.y + sin * axis.x;

            axis = ax;
            if (axis.magnitude != 0)
            {
                absAxis = axis;
            }
        }
    }

    private void InteractCallback(int index)
    {
        if (index == inputIndex)
        {
            _isInteract = true;
        }
    }


    public bool IsKeyDown(string key)
    {
        switch (key)
        {
            case "interact": return _isInteract;
        }
        return false;
    }

}
