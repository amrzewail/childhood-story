using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActorIdentity : MonoBehaviour, IActorIdentity
{
    [SerializeField] int _characterIdentifier = 0;

    public int characterIdentifier => _characterIdentifier;
}
