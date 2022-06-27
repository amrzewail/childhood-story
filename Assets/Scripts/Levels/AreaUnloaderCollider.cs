using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Scripts.Areas
{ 
    public class AreaUnloaderCollider : AreaLoaderBase
    {

        public UnityEvent OnUnload;

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
                    if (_entered.Count > 1)
                    {
                        UnloadArea();
                    }
                }
            }
        }

        public void UnloadArea()
        {
            Unload();
            OnUnload?.Invoke();
        }
    }
}