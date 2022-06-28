using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UI;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using static UnityEngine.InputSystem.InputAction;

public class CreditsUI : MonoBehaviour
{
    [SerializeField] Image overlay;

    private bool _preventTransition = false;

    private void Awake()
    {
        InputUIEvents.GetInstance().Enter += SelectCallback;
        InputUIEvents.GetInstance().Back += SelectCallback;
    }
    private void OnDestroy()
    {
        InputUIEvents.GetInstance().Enter -= SelectCallback;
        InputUIEvents.GetInstance().Back -= SelectCallback;
    }

    private IEnumerator Start()
    {
        overlay.gameObject.SetActive(true);

        overlay.color = Color.black;
        _preventTransition = true;

        yield return new WaitForSeconds(1);

        overlay.DOFade(0, 2);


        yield return new WaitForSeconds(2);

        _preventTransition = false;
    }


    public void SelectCallback()
    {
        if (_preventTransition) return;

        _preventTransition = true;


        overlay.DOFade(1, 2).onComplete += () =>
        {
            SceneManager.LoadScene("Splash");
        };
    }

    public void BackCallback()
    {
        if (_preventTransition) return;

        _preventTransition = true;

        overlay.DOFade(1, 2).onComplete += () =>
        {
            SceneManager.LoadScene("Splash");
        };

    }
}
