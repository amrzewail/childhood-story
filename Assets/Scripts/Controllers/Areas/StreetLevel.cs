using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class StreetLevel : MonoBehaviour
{

    public UnityEvent OnCompleteInteractions;


    public static StreetLevel Instance { get; private set; }


    private bool _isInteractedPaper;
    private bool _isInteractedCat;


    private void Awake()
    {
        if (Instance)
        {
            Destroy(this.gameObject);
            return;
        }

        Instance = this;

        DontDestroyOnLoad(this.gameObject);
    }


    public void SetPaperInteractionStarted()
    {
        _isInteractedPaper = true;

        if (_isInteractedCat && _isInteractedPaper)
        {
            OnCompleteInteractions?.Invoke();
        }
    }

    public void SetCatInteractionStarted()
    {
        _isInteractedCat = true;

        if(_isInteractedCat && _isInteractedPaper)
        {
            OnCompleteInteractions?.Invoke();
        }
    }
}
