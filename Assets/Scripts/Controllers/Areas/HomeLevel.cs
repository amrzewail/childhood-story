using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class HomeLevel : Singleton<HomeLevel>
{

    public UnityEvent OnStartOpenDoors;



    private bool _isInteractedDarkDoor;
    private bool _isInteractedLightDoor;

    public void SetDarkDoorInteracted()
    {
        _isInteractedDarkDoor = true;

        if(_isInteractedDarkDoor && _isInteractedLightDoor)
        {
            OnStartOpenDoors?.Invoke();
        }
    }

    public void SetLightDoorInteracted()
    {
        _isInteractedLightDoor = true;

        if(_isInteractedLightDoor && _isInteractedDarkDoor)
        {
            OnStartOpenDoors?.Invoke();
        }
    }
}
