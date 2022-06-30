using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CameraEffects : MonoBehaviour
{
    private static CameraEffects _instance;

    [SerializeField] private Image _fadeImage;

    private void Awake()
    {
        _instance = this;
    }

    public static void Fade(float endValue, float duration = 1, float delay=0)
    {
        _instance._fadeImage.DOKill();

        var tweener = _instance._fadeImage.DOFade(endValue, duration).SetDelay(delay);

        if(endValue <= 0.001f)
        {
            tweener.onComplete += () => _instance._fadeImage.gameObject.SetActive(false);
        }
        else {

            _instance._fadeImage.gameObject.SetActive(true);
        }
    }
    public static void FadeInstant(float endValue)
    {
        _instance._fadeImage.color = new Color(_instance._fadeImage.color.r, _instance._fadeImage.color.g, _instance._fadeImage.color.b, endValue);
        if(endValue <= 0.001f)
        {
            _instance._fadeImage.gameObject.SetActive(false);
        }
        else
        {
            _instance._fadeImage.gameObject.SetActive(true);
        }
    }
}
