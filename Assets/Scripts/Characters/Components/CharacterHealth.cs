using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterHealth : MonoBehaviour, IActorHealth
{
    [SerializeField] int _maxHealth = 5;
    [SerializeField] int _currentHealth = 5;

    internal void Start()
    {
        _currentHealth = _maxHealth;
    }


    public void Damage(int amount)
    {
        _currentHealth -= amount;
        if (_currentHealth < 0) _currentHealth = 0;
    }

    public int GetMaxValue()
    {
        return _maxHealth;
    }

    public int GetValue()
    {
        return _currentHealth;
    }

    public void Heal(int amount)
    {
        _currentHealth += amount;
        if (_currentHealth > _maxHealth) _currentHealth = _maxHealth;
    }

    public bool IsDead()
    {
        return (_currentHealth <= 0);
    }
}
