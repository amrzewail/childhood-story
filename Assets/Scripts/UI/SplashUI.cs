using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UI;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using static UnityEngine.InputSystem.InputAction;

public class SplashUI : MonoBehaviour
{
    [SerializeField] AudioClip BGM;

    [SerializeField] Image overlay;
    [SerializeField] TextMeshProUGUI text;


    private void Awake()
    {
        InputUIEvents.GetInstance().Enter += SelectCallback;
    }
    private void OnDestroy()
    {
        InputUIEvents.GetInstance().Enter -= SelectCallback;
    }

    private IEnumerator Start()
    {
        overlay.color = Color.black;

        yield return new WaitForSeconds(1);


        BGMPlayer.GetInstance().Play(BGM);

        overlay.DOFade(0, 1);
    }

    private void Update()
    {
        text.color = new Color(text.color.r, text.color.g, text.color.b, 1 - Mathf.Pow(Mathf.Sin(Time.time * 2), 2));
    }

    public void SelectCallback()
    {
        SceneManager.LoadScene("Main Menu UI");
    }
}
