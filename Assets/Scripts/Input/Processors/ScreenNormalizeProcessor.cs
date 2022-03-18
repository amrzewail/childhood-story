using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

#if UNITY_EDITOR
using UnityEditor;
[InitializeOnLoad]
#endif
public class ScreenNormalizeProcessor : InputProcessor<Vector2>
{
//#if UNITY_EDITOR
//    static ScreenNormalizeProcessor()
//    {
//        Initialize();
//    }
//#endif

//    [RuntimeInitializeOnLoadMethod(loadType:RuntimeInitializeLoadType.AfterAssembliesLoaded)]
//    static void Initialize()
//    {
//        InputSystem.RegisterProcessor<ScreenNormalizeProcessor>("Screen Normalize");
//    }


    public override Vector2 Process(Vector2 value, InputControl control)
    {
        return value * (1f / Screen.height);
    }
}
