using System.Collections;
using System.Collections.Generic;
using UI;
using UnityEngine;
using static UnityEngine.InputSystem.InputAction;

public class SelectorsUI : MonoBehaviour
{
    public Selections selections;

    public void UpCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
            selections.Up();
    }

    public void DownCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
            selections.Down();
    }

    public void SelectCallback(CallbackContext context)
    {
        if (context.phase == UnityEngine.InputSystem.InputActionPhase.Started)
        {
            selections.Select();
        }
    }
}
