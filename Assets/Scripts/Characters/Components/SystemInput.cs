using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;



public class SystemInput : MonoBehaviour
{
    private static int _inputCount = 0;

    private int _inputIndex = 0;


    internal void Start()
    {
        _inputIndex = _inputCount++;
        DontDestroyOnLoad(this.gameObject);

        InputEvents.instance.OnClearInput += ClearInputCallback;
    }

    internal void OnDestroy()
    {
        _inputCount--;
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

    private void ClearInputCallback(int index)
    {
        if(index == _inputIndex)
        {
            Destroy(this.gameObject);
        }
    }

}
