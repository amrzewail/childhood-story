using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightDetectionDisabler : MonoBehaviour
{
    private List<IActor> _actors = new List<IActor>();

    private void Update()
    {
        foreach(var actor in _actors)
        {
            if (actor.GetActorComponent<IActorHealth>().IsDead())
            {
                actor.GetActorComponent<ILightDetector>().isActive = true;

                if (_actors.Contains(actor))
                {
                    _actors.Remove(actor);
                }
                break;
            }
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        IActor actor = null;
        if ((actor = other.GetComponent<IActor>()) != null)
        {
            int id = actor.GetActorComponent<IActorIdentity>().characterIdentifier;

            if(id < 2)
            {
                actor.GetActorComponent<ILightDetector>().isActive = false;

                if (!_actors.Contains(actor))
                {
                    _actors.Add(actor);
                }
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        IActor actor = null;
        if ((actor = other.GetComponent<IActor>()) != null)
        {
            int id = actor.GetActorComponent<IActorIdentity>().characterIdentifier;

            if (id < 2)
            {
                actor.GetActorComponent<ILightDetector>().isActive = true;

                if (_actors.Contains(actor))
                {
                    _actors.Remove(actor);
                }
            }
        }
    }
}
