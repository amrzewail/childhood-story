using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class LightDetector : MonoBehaviour, ILightDetector
{
    public bool isOnLight { get; private set; }

    private int _lastLight = -1;

    public UnityEvent OnLight;
    public UnityEvent OnShadow;

    private void FixedUpdate()
    {
        bool isLight = LightTypeCalculator.IsPositionLighted(transform.position);

        if (isLight)
        {
            if(_lastLight != 1)
            {
                OnLight?.Invoke();
                _lastLight = 1;
            }
        }
        else
        {
            if(_lastLight != 0)
            {
                OnShadow?.Invoke();
                _lastLight = 0;
            }
        }
        isOnLight = isLight;
    }
}
