using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PusherCharacter : MonoBehaviour
{
    public Pusher pusher;
    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.E))
        {
            pusher.StartPush(null);
        }
        if(Input.GetKeyUp(KeyCode.E))
        {
            pusher.StopPush(null);
        }    
    }
}
