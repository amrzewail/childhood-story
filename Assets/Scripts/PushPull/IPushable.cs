using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IPushable
{
    void StartPush(IDictionary<string, object> data);
    void StopPush(IDictionary<string, object> data);


}