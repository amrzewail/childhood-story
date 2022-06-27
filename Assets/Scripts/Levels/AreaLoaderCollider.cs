using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scripts.Areas
{ 
    public class AreaLoaderCollider : AreaLoaderBase
    {
        [SerializeField] int _activateOnCount = 2;

        private List<int> _entered = new List<int>();

        private void OnTriggerEnter(Collider other)
        {
            var actor = other.GetComponent<IActor>();
            if (actor != null)
            {
                int? identifier = actor.GetActorComponent<IActorIdentity>()?.characterIdentifier;
                if (identifier != null && !_entered.Contains(identifier.Value))
                {
                    _entered.Add(identifier.Value);
                    if (_entered.Count >= _activateOnCount)
                    {
                        LoadArea();
                    }
                }

            }
        }

        public void LoadArea()
        {
            Load();
        }
    }
}