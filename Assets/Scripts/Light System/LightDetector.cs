using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class LightDetector : MonoBehaviour, ILightDetector
{
    [SerializeField] LayerMask _obstacleLayerMask;

    public bool isOnLight { get; private set; }

    private int _lastLight = -1;

    public UnityEvent OnLight;
    public UnityEvent OnShadow;

    private void FixedUpdate()
    {
        List<LightEffector> lights = LightEffector.effectors;
        if (lights == null) return;

        bool isLight = false;
        foreach(var light in lights)
        {
            if(LightTypeCalculator.IsLightHit(transform.position, light, _obstacleLayerMask))
            {
                isLight = true;
                break;
            }
        }

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

    internal void Reset()
    {
        _obstacleLayerMask = LayerMask.GetMask(new string[] { "Obstacle" });
    }
}
