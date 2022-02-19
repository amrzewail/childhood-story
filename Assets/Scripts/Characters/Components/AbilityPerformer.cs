using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AbilityPerformer : MonoBehaviour, IAbilityPerformer
{

    [SerializeField] [RequireInterface(typeof(IAbility))] List<Object> _abilities;

    private IAbility _currentAbility;

    public bool CanPerform(int index)
    {
        var ability = GetAbility(index);
        if (ability != null) return ability.CanPerform();
        return false;
    }

    public IAbility GetAbility(int index)
    {
        if (_abilities.Count <= index) return null;
        return (IAbility)_abilities[index];
    }

    public bool IsComplete()
    {
        if (_currentAbility == null) return true;
        return _currentAbility.IsComplete();
    }

    public void Perform(int index)
    {
        _currentAbility = GetAbility(index);
        if (_currentAbility != null) _currentAbility.Perform();
    }
}
