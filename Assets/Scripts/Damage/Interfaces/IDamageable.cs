using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IDamageable
{
    DamageGroup group { get; }
    bool Damage(IDamage dmg);

    bool isActive { get; set; }

}
