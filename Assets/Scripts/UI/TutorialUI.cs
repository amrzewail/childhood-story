using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TutorialUI : MonoBehaviour
{
    public static Action<int> SHOW;

    public static Action HIDE;

    private int _index = -1;

    private void Awake()
    {
        SHOW += ShowCallback;
        HIDE += HideCallback;
    }

    private void OnDestroy()
    {
        SHOW -= ShowCallback;
        HIDE -= HideCallback;
    }

    private void ShowCallback(int index)
    {
        Show(index);
    }

    private void HideCallback()
    {
        Show(-1);
    }

    private void FixedUpdate()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            transform.GetChild(i).gameObject.SetActive(i == _index);
        }

        if (_index != -1)
        {
            _index = -1;
        }
    }

    public void Show(int index)
    {
        _index = index;
    }
}
