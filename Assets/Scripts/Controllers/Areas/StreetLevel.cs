using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class StreetLevel : MonoBehaviour
{

    [SerializeField] AudioClip _cutsceneClip;

    private bool _didStartCutsceneClip = false;

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

            ICamera camera = this.FindInterfaceOfType<ICamera>();
            float value = 1f;
            DOTween.To(() => value, x =>
            {
                value = x;
                camera.Zoom(value);
            }, 1.25f, 5);

            if (!_didStartCutsceneClip)
            {
                BGMPlayer.GetInstance().Play(_cutsceneClip);
            }
            _didStartCutsceneClip = true;
        }
    }

    public void SetCatInteractionStarted()
    {
        _isInteractedCat = true;

        if(_isInteractedCat && _isInteractedPaper)
        {
            OnCompleteInteractions?.Invoke();

            ICamera camera = this.FindInterfaceOfType<ICamera>();
            float value = 1f;
            DOTween.To(() => value, x =>
            {
                value = x;
                camera.Zoom(value);
            }, 1.25f, 5);

            if (!_didStartCutsceneClip)
            {
                BGMPlayer.GetInstance().Play(_cutsceneClip);
            }
            _didStartCutsceneClip = true;
        }
    }
}
