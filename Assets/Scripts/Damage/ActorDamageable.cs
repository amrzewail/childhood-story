using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ActorDamageable : MonoBehaviour, IDamageable
{
    public bool isActive { get; set; } = true;


    public DamageGroup group { get => _group; }
    public IActor actor => (IActor)_actor;

    public UnityEvent<int> OnDamage;
    public UnityEvent<IDamage> OnDamageWithData;

    [SerializeField] [RequireInterface(typeof(IActor))] Object _actor;
    [SerializeField] DamageGroup _group;
    [SerializeField] Collider trigger;



    public bool Damage(IDamage dmg)
    {
        if (!isActive) return false;

        if (dmg.groups.Contains(group))
        {
            actor.GetActorComponent<IActorHealth>(0).Damage(dmg.amount);
            OnDamage?.Invoke(dmg.amount);
            OnDamageWithData?.Invoke(dmg);
            return true;
        }
        return false;
    }

    private void Update()
    {
        trigger.enabled = !actor.GetActorComponent<IActorHealth>(0).IsDead();
    }
}