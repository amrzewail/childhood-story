using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputEvents : Singleton<InputEvents>
{

    public Action<int, Vector2> OnMove;

    public Action<int> OnInteract;

    public Action<int> OnClearInput;
}
