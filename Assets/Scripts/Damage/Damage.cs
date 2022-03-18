using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Damage : IDamage
{
    public List<DamageGroup> groups { get; }
    public IDamager damager { get; set; }
    public int amount { get; set; }
}
