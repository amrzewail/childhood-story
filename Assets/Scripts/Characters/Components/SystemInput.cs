using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;



public class SystemInput : MonoBehaviour
{
    private int _inputIndex = 0;


    internal void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;

        _inputIndex = GetComponent<PlayerInput>().playerIndex;
        DontDestroyOnLoad(this.gameObject);

        InputEvents.instance.OnClearInput += ClearInputCallback;

        for(int i = 0; i < _inputIndex; i++)
        {
            InputEvents.instance.OnMove?.Invoke(i, Vector2.zero);
        }
    }


    public void onMove(InputAction.CallbackContext context)
    {
        var axis = context.ReadValue<Vector2>();
        InputEvents.instance.OnMove?.Invoke(_inputIndex, axis);

    }

    public void OnInteract(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            InputEvents.instance.OnInteract?.Invoke(_inputIndex);
        }
    }
    public void OnAbility(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            InputEvents.instance.OnAbility?.Invoke(_inputIndex);
        }
    }
    public void OnShoot(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            InputEvents.instance.OnShoot?.Invoke(_inputIndex);
        }
    }
    public void OnAim(InputAction.CallbackContext context)
    {
        Vector2 value = context.ReadValue<Vector2>();
        if (context.control.device.deviceId == Mouse.current.deviceId)
        {
            if(value.magnitude > 5)
            {
                InputEvents.instance.OnAim?.Invoke(_inputIndex, value);
            }
            Debug.Log($"mouse value x:{value.x} y:{value.y} mag:{value.magnitude}");
        }
        else
        {
            InputEvents.instance.OnAim?.Invoke(_inputIndex, value);
        }

    }

    private void ClearInputCallback(int index)
    {
        if(index == _inputIndex)
        {
            Destroy(this.gameObject);
        }
    }

}
