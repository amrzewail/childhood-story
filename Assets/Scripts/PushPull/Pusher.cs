using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pusher : MonoBehaviour,IPusher
{
    private IPushable availablepushable = null;

    private IPushable currentpushable = null;
    private bool _ispushing = false;
    public IPushable GetPushable()
    {
        if (_ispushing) return currentpushable;
        return availablepushable;
    }

    public void StartPush(IDictionary<string, object> data)
    {
        if (availablepushable == null) return;
        _ispushing = true;
        currentpushable = availablepushable;
        currentpushable.StartPush(data);

    }

    public void StopPush(IDictionary<string, object> data)
    {
        _ispushing = false;
        currentpushable.StopPush(data);
        currentpushable = null;
    }
    private void OnTriggerEnter(Collider other)
    {
        var pushable = other.GetComponent<IPushable>();
        if (pushable == null) { return; }
        availablepushable = pushable;
    }
    private void OnTriggerExit(Collider other)
    {
        var pushable = other.GetComponent<IPushable>();

        if (pushable == null) { return; }

        if (pushable != availablepushable) { return; }

        availablepushable = null;
    }

}
