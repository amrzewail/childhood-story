using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class LightDetector : MonoBehaviour, ILightDetector
{
    [SerializeField] [ReadOnly] private bool _isActive = true;


    public bool isActive { get => _isActive; set
        {
            _isActive = value;
            if (_isActive)
            {
                FixedUpdate();
            }
        }
    }
    public bool isOnLight { get; private set; }
    [SerializeField] private bool startingValue;
    private int _lastLight = -1;

    public UnityEvent OnLight;
    public UnityEvent OnShadow;
    private void Awake()
    {
        isOnLight = startingValue;
    }
    private void FixedUpdate()
    {
        if (isActive == false) return;

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
