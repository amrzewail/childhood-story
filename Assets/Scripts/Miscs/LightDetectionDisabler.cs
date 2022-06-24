using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightDetectionDisabler : MonoBehaviour
{

    private void OnTriggerEnter(Collider other)
    {
        IActor actor = null;
        if ((actor = other.GetComponent<IActor>()) != null)
        {
            int id = actor.GetActorComponent<IActorIdentity>().characterIdentifier;

            if(id < 2)
            {
                actor.GetActorComponent<ILightDetector>().isActive = false;
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
            }
        }
    }
}
