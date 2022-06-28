using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.InputSystem.InputAction;

public class InputUIEvents : Singleton<InputUIEvents>
{

    public Action Up;
    public Action Down;
    public Action Left;
    public Action Right;
    public Action Enter;
    public Action Start;
    public Action Back;
}
