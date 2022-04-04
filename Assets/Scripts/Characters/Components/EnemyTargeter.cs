using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyTargeter : MonoBehaviour, ITargeter
{
    private ITargetable _target;
    [SerializeField] private List<TargetType> _supportedTypes;

    public bool isThereATarget => _target != null;

    public List<TargetType> supportedTypes => _supportedTypes;

    public ITargetable GetTarget()
    {
        return _target;
    }

    private void OnTriggerEnter(Collider other)
    {
        ITargetable t;
        if((t = other.GetComponent<ITargetable>())!= null)
        {
            if (supportedTypes.Contains(t.targetType) && t.isTargetable)
            {
                _target = t;
            }
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
