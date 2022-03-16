using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IPusher:IComponent
{
    Transform holdingPoint { get;}
    IPushable GetPushable();
    void StartPush(IDictionary<string, object> data);
    void StopPush(IDictionary<string, object> data);


}