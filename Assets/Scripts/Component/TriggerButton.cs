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
    public UnityEvent OnButtonUpOnce;

    public UnityEvent OnSoundDown;
    public UnityEvent OnSoundUp;

    private bool _isButtonDown;

    private Vector3 startPosition;

    private void Start()
    {
        startPosition = renderer.transform.position;

        OnButtonUp?.Invoke();
        OnButtonUpOnce?.Invoke();
    }

    public void ButtonDown(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            renderer.transform.position = startPosition + Vector3.down * pressDistance;
            OnButtonDown?.Invoke();
            OnSoundDown?.Invoke();

            _isButtonDown = true;
        }
    }
    public void ButtonUp(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            renderer.transform.position = startPosition;
            OnButtonUp?.Invoke();
            OnSoundUp?.Invoke();
            if (_isButtonDown)
            {
                OnButtonUpOnce?.Invoke();
                _isButtonDown = false;
            }
        }
    }
}
