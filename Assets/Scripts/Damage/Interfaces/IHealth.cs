using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IHealth
{
    int GetValue();

    int GetMaxValue();

    void Damage(int amount);

    void Heal(int amount);

    bool IsDead();
}