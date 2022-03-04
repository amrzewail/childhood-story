using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

public class AnimatorEventInvoker : MonoBehaviour
{
    [System.Serializable]
    public struct Event
    {
        public string eventName;
        public UnityEvent<string> OnEvent;
    }

    [SerializeField] Event[] _events;

    public void InvokeEvent(AnimationEvent ev)
    {
        _events.Single(x => x.eventName.Equals(ev.eventName)).OnEvent?.Invoke(ev.value);
    }
}
