using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Killbox : MonoBehaviour, IDamager
{
    public UnityEvent OnKill;

    public bool isEnabled { get; set; } = true;

    public Transform casterTransform { get; set; }

    internal void OnTriggerEnter(Collider other)
    {
        if (!isEnabled) return;

        IActor actor;
        if ((actor = other.GetComponent<IActor>()) != null)
        {
            actor.GetActorComponent<IActorHealth>().Damage(1000);
        }
    }
}
