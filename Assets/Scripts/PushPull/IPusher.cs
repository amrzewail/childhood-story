using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IPusher:IComponent
{
    IPushable GetPushable();
    void StartPush(IDictionary<string, object> data);
    void StopPush(IDictionary<string, object> data);


}