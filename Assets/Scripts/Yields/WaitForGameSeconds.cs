using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaitForGameSeconds : CustomYieldInstruction
{
    private float _seconds;

    private float _currentSeconds = 0;

    public override bool keepWaiting
    {
        get
        {
            _currentSeconds += TimeManager.gameDeltaTime;

            if (_currentSeconds > _seconds) return false;

            return true;
        }
    }

    public WaitForGameSeconds(float seconds)
    {
        _currentSeconds = 0;
        _seconds = seconds;
    }
}
