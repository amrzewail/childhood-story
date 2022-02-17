using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

using Object = UnityEngine.Object;

public static class ObjectExt
{
    public static T FindInterfaceOfType<T>(this Object obj)
    {
        IEnumerable<T> objs = Object.FindObjectsOfType<MonoBehaviour>().OfType<T>();
        if (objs != null && objs.Count() > 0) return objs.ElementAt(0);
        return default(T);
    }

    public static T[] FindInterfacesOfType<T>(this Object obj)
    {
        var objs = Object.FindObjectsOfType<MonoBehaviour>().OfType<T>();
        if (objs != null) return objs.ToArray();
        return null;
    }
}
