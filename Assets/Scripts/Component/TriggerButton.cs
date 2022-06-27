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

    public bool IsButtonDown => _isButtonDown;

    private void Awake()
    {
        startPosition = renderer.transform.position;

        OnButtonUp?.Invoke();
        OnButtonUpOnce?.Invoke();
    }

    private void OnEnable()
    {
        if (_isButtonDown)
        {
            Vector3 pos = renderer.transform.position;
            pos.y = startPosition.y;
            renderer.transform.position = pos;
            _isButtonDown = false;
        }
    }

    public void ButtonDown(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            Vector3 pos = renderer.transform.position;
            pos.y = startPosition.y;

            renderer.transform.position = pos + Vector3.down * pressDistance;
            OnButtonDown?.Invoke();
            OnSoundDown?.Invoke();

            _isButtonDown = true;
        }
    }
    public void ButtonUp(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            Vector3 pos = renderer.transform.position;
            pos.y = startPosition.y;

            renderer.transform.position = pos;
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
