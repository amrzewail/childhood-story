using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageMono : MonoBehaviour, IDamage
{
    public List<DamageGroup> groups => _groups;

    public IDamager damager { get; set; }
    public int amount { get => _amount; set => _amount = value; }

    [SerializeField] List<DamageGroup> _groups;
    [SerializeField] int _amount;
}
