using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IDamage
{
    public List<DamageGroup> groups { get; }

    IDamager damager { get; set; }

    int amount { get; set; }
}
