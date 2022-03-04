using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Animation Event", menuName = "Animations/Animation Event")]
public class AnimationEvent : ScriptableObject
{
    public string eventName => this.name;
    public string value;
}
