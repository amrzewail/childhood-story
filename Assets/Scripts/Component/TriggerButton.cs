using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TriggerButton : MonoBehaviour
{
    [SerializeField]
    GameObject renderer;
    [SerializeField]
    float pressDistance=0.2f;

    public UnityEvent OnButtonDown;
    public UnityEvent OnButtonUp;

    public void ButtonDown(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            renderer.transform.Translate(Vector3.down * pressDistance);
            OnButtonDown?.Invoke();
        }
    }
    public void ButtonUp(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            renderer.transform.Translate(Vector3.up * pressDistance);
            OnButtonUp?.Invoke();
        }
    }
}
