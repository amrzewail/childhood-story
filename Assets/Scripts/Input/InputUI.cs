using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.InputSystem.InputAction;

public class InputUI : MonoBehaviour
{
    public void UpCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Up?.Invoke();
        }
    }
    public void DownCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Down?.Invoke();
        }
    }
    public void RightCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Right?.Invoke();
        }
    }
    public void LeftCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Left?.Invoke();
        }
    }
    public void EnterCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Enter?.Invoke();
        }
    }
    public void StartCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Start?.Invoke();
        }
    }
    public void BackCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            InputUIEvents.GetInstance().Back?.Invoke();
        }
    }
}
