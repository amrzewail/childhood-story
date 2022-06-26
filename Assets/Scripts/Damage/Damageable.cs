using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Damageable : MonoBehaviour, IDamageable
{
    public DamageGroup group { get => _group; }

    public bool isActive { get; set; } = true;

    public UnityEvent<int> OnDamage;

    [SerializeField] DamageGroup _group;

    public bool Damage(IDamage dmg)
    {
        if (!isActive) return false;

        if (dmg.groups.Contains(group))
        {
            OnDamage?.Invoke(dmg.amount);
            return true;
        }
        return false;
    }
}
