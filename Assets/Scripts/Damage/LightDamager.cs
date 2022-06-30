using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightDamager : MonoBehaviour
{
    [SerializeField] [RequireInterface(typeof(ILightDetector))] Object _lightDetector;
    [SerializeField] [RequireInterface(typeof(IHealth))] Object _health;
    [SerializeField] DamageType damageOn;

    public ILightDetector lightDetector => (ILightDetector)_lightDetector;
    public IHealth health => (IHealth)_health;

    public enum DamageType
    {
        DamageOnLight,
        DamageOnDark
    }

    private void LateUpdate()
    {
        //return;

        if (lightDetector.isActive == false) return;

        if(!health.IsDead())
        {
            bool isOnLight = lightDetector.isOnLight;

            if(isOnLight && damageOn == DamageType.DamageOnLight)
            {
                health.Damage(health.GetValue());
                Debug.Log($"{nameof(LightDamager)} Damage on light");
            }else if (!isOnLight && damageOn == DamageType.DamageOnDark)
            {
                health.Damage(health.GetValue());
                Debug.Log($"{nameof(LightDamager)} Damage on dark");
            }
        }
    }
}
