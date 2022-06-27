using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DelayCall : MonoBehaviour
{
    [SerializeField] UnityEvent call;
    [SerializeField] float delay;

    public async void Invoke()
    {
        await System.Threading.Tasks.Task.Delay((int)(delay * 1000));

        if (this)
        {
            call?.Invoke();
        }
    }

}
