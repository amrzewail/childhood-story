using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Damager : MonoBehaviour, IDamager
{
    [SerializeField] [RequireInterface(typeof(IDamage))] Object _damage;
    public UnityEvent OnDamage;

    public bool isEnabled { get; set; } = true;
    public IDamage damage => (IDamage)_damage;

    internal void OnTriggerEnter(Collider other)
    {
        if (!isEnabled) return;

        IDamageable damageable;
        if ((damageable = other.GetComponent<IDamageable>()) != null)
        {
            damage.damager = this;
            if (damageable.Damage(damage))
            {
                OnDamage?.Invoke();
            }
        }
    }
}
