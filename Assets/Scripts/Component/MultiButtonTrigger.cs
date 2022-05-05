using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MultiButtonTrigger : MonoBehaviour
{
    [SerializeField] TriggerButton[] buttons;
    [SerializeField] bool oneTimeOnly;

    public UnityEvent OnButtonsDown;
    public UnityEvent OnButtonsUp;

    private bool _isTriggered = false;

    private void Update()
    {
        int downCount = 0;
        for (int i = 0; i < buttons.Length; i++)
        {
            if (buttons[i].IsButtonDown)
            {
                downCount++;
            }
        }

        if(downCount == buttons.Length)
        {
            if (!_isTriggered)
            {
                OnButtonsDown?.Invoke();
                _isTriggered = true;
            }
        }
        else
        {
            if (_isTriggered && !oneTimeOnly)
            {
                OnButtonsUp?.Invoke();
                _isTriggered = false;
            }
        }
    }
}
