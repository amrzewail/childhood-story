using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class CharacterHealth : MonoBehaviour, IActorHealth
{
    [SerializeField] int _maxHealth = 5;
    [SerializeField] int _currentHealth = 5;

    [SerializeField] UnityEvent OnDead;
    [SerializeField] UnityEvent OnRise;

    private bool _dead = false;

    internal void Start()
    {
        _currentHealth = _maxHealth;
        _dead = IsDead();
    }


    public void Damage(int amount)
    {
        _currentHealth -= amount;
        if (_currentHealth < 0) _currentHealth = 0;

        if (IsDead() && _dead != IsDead())
        {
            _dead = IsDead();
            OnDead?.Invoke();
        }
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
        if (!IsDead() && _dead != IsDead())
        {
            _dead = IsDead();
            OnRise?.Invoke();
        }
    }

    public bool IsDead()
    {
        return (_currentHealth <= 0);
    }
}
