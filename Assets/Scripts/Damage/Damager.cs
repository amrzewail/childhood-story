using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Damager : MonoBehaviour, IDamager
{
    [SerializeField] [RequireInterface(typeof(IDamage))] Object _damage;
    public UnityEvent OnDamage;

    public IDamage damage => (IDamage)_damage;

    internal void OnTriggerEnter(Collider other)
    {
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
