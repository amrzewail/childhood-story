using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;



public class SystemInput : MonoBehaviour, IInput
{

    public Vector2 axis { get; private set; }

    public Vector2 absAxis { get; private set; }

    public void onMove(InputAction.CallbackContext context)
    {
        axis = context.ReadValue<Vector2>();
        if(axis.magnitude != 0)
        {
            absAxis = axis;
        }
    }
    private void Update()
    {
        
    }

    public bool IsKeyDown(string key)
    {
        return false;
    }

}
