using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IPushable
{ 
    bool CanPush();
    void StartPush(IDictionary<string, object> data);
    void StopPush(IDictionary<string, object> data);


}