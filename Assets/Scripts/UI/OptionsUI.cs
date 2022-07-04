using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UI;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using static UnityEngine.InputSystem.InputAction;

public class OptionsUI : MonoBehaviour
{
    //[SerializeField] Image overlay;

    //private bool _preventTransition = false;

    [SerializeField] Transform layouts;

    private int _currentLayout = 0;

    private void Awake()
    {
        InputUIEvents.GetInstance().Enter += SelectCallback;
        InputUIEvents.GetInstance().Back += SelectCallback;

        InputUIEvents.GetInstance().Right += RightCallback;
        InputUIEvents.GetInstance().Left += LeftCallback;

    }
    private void OnDestroy()
    {
        InputUIEvents.GetInstance().Enter -= SelectCallback;
        InputUIEvents.GetInstance().Back -= SelectCallback;


        InputUIEvents.GetInstance().Right -= RightCallback;
        InputUIEvents.GetInstance().Left -= LeftCallback;
    }

    private void Start()
    {
        _currentLayout = 0;
        for(int i=0;i<layouts.childCount; i++)
        {
            layouts.GetChild(i).gameObject.SetActive(i == _currentLayout);
        }
    }


    public void SelectCallback()
    {
        SceneManager.LoadScene("Main Menu UI");

    }

    public void BackCallback()
    {
        SceneManager.LoadScene("Main Menu UI");

    }

    private void RightCallback()
    {
        _currentLayout++;
        _currentLayout = _currentLayout % layouts.childCount;
        for (int i = 0; i < layouts.childCount; i++)
        {
            layouts.GetChild(i).gameObject.SetActive(i == _currentLayout);
        }
    }

    private void LeftCallback()
    {
        _currentLayout--;
        _currentLayout = _currentLayout < 0 ? layouts.childCount - 1 : _currentLayout;
        for (int i = 0; i < layouts.childCount; i++)
        {
            layouts.GetChild(i).gameObject.SetActive(i == _currentLayout);
        }
    }
}
