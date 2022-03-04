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

    public UnityEvent OnSoundDown;
    public UnityEvent OnSoundUp;

    private Vector3 startPosition;

    private void Start()
    {
        startPosition = renderer.transform.position;
    }

    public void ButtonDown(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            renderer.transform.position = startPosition + Vector3.down * pressDistance;
            OnButtonDown?.Invoke();
            OnSoundDown?.Invoke();
        }
    }
    public void ButtonUp(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            renderer.transform.position = startPosition;
            OnButtonUp?.Invoke();
            OnSoundUp?.Invoke();
        }
    }
}
