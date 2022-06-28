using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class HomeLevel : Singleton<HomeLevel>
{

    public UnityEvent OnStartOpenDoors;
    public UnityEvent OnRoomCutsceneCompleted;
    public UnityEvent OnUniteCutsceneCompleted;


    private bool _isInteractedDarkDoor;
    private bool _isInteractedLightDoor;

    private bool _isDarkCutsceneComplete;
    private bool _isLightCutsceneComplete;

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

    public void SetDarkRoomCutsceneComplete()
    {
        _isDarkCutsceneComplete = true; 
        if (_isLightCutsceneComplete)
        {
            OnRoomCutsceneCompleted?.Invoke();
        }
    }

    public void SetLightRoomCutsceneComplete()
    {
        _isLightCutsceneComplete = true;
        if (_isDarkCutsceneComplete)
        {
            OnRoomCutsceneCompleted?.Invoke();
        }
    }

    public void SetUniteCutsceneComplete()
    {
        OnUniteCutsceneCompleted?.Invoke();
    }
}
