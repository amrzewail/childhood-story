using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightFlicker : MonoBehaviour
{
    [SerializeField] [Range(0, 1)] float intensityRange = 0.5f;
    [SerializeField] float speed = 1;
    [SerializeField] LightEffector effector;

    private float _lightIntensity = 0;
    private Light _light;

    // Start is called before the first frame update
    void Start()
    {
        _light = GetComponentInChildren<Light>();
        _lightIntensity = _light.intensity;
    }

    // Update is called once per frame
    void Update()
    {
        _light.intensity = _lightIntensity + Mathf.Sin(Time.time * speed) * intensityRange * _lightIntensity;

        if (effector)
        {
            if (_light.intensity <= 0.1f)
            {
                if (effector.enabled) effector.enabled = false;
            }
            else
            {
                if (effector.enabled == false) effector.enabled = true;
            }
        }
    }
}
