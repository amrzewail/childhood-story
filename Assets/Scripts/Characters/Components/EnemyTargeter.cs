using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyTargeter : MonoBehaviour, ITargeter
{

    [SerializeField] [RequireInterface(typeof(IMover))] Object _mover;
    public IMover mover => (IMover)_mover;

    private ITargetable _target;
    [SerializeField] private List<TargetType> _supportedTypes;

    public bool isThereATarget => _target != null;

    public List<TargetType> supportedTypes => _supportedTypes;

    public ITargetable GetTarget()
    {
        return _target;
    }

    public void DamageCallback(IDamage dmg)
    {
        if (dmg.damager.casterTransform)
        {
            ITargetable t = dmg.damager.casterTransform.GetComponentInChildren<ITargetable>();
            if(t != null)
            {
                CheckTarget(t);
            }
        }
    }

    private void CheckTarget(ITargetable t)
    {
        if (supportedTypes.Contains(t.targetType) && t.isTargetable)
        {
            _target = t;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        ITargetable t;
        if((t = other.GetComponent<ITargetable>())!= null)
        {
            CheckTarget(t);
        }
    }
    private void OnTriggerExit(Collider other)
    {
        ITargetable t;
        if ((t = other.GetComponent<ITargetable>()) != null)
        {
            if(_target == t)
            {
                //_target = null;
            }

        }
    }
}
