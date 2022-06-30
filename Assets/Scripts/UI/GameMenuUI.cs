using System;
using System.Collections;
using System.Collections.Generic;
using UI;
using UnityEngine;
using UnityEngine.SceneManagement;
using static UnityEngine.InputSystem.InputAction;

public class GameMenuUI : MonoBehaviour
{
    enum State
    {
        Closed,
        Pause
    }

    public GameObject pause;
    public Selections pauseSelections;
    public GameObject intro;

    private State _state = State.Closed;

    private bool _didChangeState = false;
    private bool _isShowingIntro = false;


    private void Start()
    {
        InputUIEvents.GetInstance().Start += StartCallback;
        InputUIEvents.GetInstance().Up += UpCallback;
        InputUIEvents.GetInstance().Down += DownCallback;
        InputUIEvents.GetInstance().Enter += SelectCallback;
        InputUIEvents.GetInstance().Back += BackCallback;

        SetState(State.Closed);

        if (SaveManager.GetInstance().isNewGame)
        {
            StartCoroutine(ShowIntro());
        }
        else
        {
            intro.gameObject.SetActive(false);
        }
    }

    private void OnDestroy()
    {
        TimeManager.uiTimeScale = 1;

        InputUIEvents.GetInstance().Start -= StartCallback;
        InputUIEvents.GetInstance().Up -= UpCallback;
        InputUIEvents.GetInstance().Down -= DownCallback;
        InputUIEvents.GetInstance().Enter -= SelectCallback;
        InputUIEvents.GetInstance().Back -= BackCallback;

    }

    private void LateUpdate()
    {
        _didChangeState = false;
    }


    private void SetState(State state)
    {
        if (_didChangeState) return;
        if (_isShowingIntro) return;

        _state = state;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;

        switch (_state)
        {
            case State.Closed:
                Cursor.visible = false;
                pause.SetActive(false);
                InputEvents.GetInstance().OnInputActivate?.Invoke(true);

                TimeManager.uiTimeScale = 1f;

                break;

            case State.Pause:
                pause.SetActive(true);
                InputEvents.GetInstance().OnInputActivate?.Invoke(false);

                TimeManager.uiTimeScale = 0.0001f;
                break;
        }

        _didChangeState = true;
    }


    public void StartCallback()
    {
        switch (_state)
        {
            case State.Closed:
                SetState(State.Pause);
                break;

            case State.Pause:
                SetState(State.Closed);
                break;
        }
    }


    public void UpCallback()
    {
        if (_state == State.Closed) return;

        switch(_state)
        {
            case State.Pause:
                pauseSelections.Up();
                break;
        }
    }

    public void DownCallback()
    {
        if (_state == State.Closed) return;

        switch (_state)
        {
            case State.Pause:
                pauseSelections.Down();
                break;
        }
    }

    public void SelectCallback()
    {
        if (_state == State.Closed) return;

        switch (_state)
        {
            case State.Pause:
                pauseSelections.Select();
                break;
        }
    }

    public IEnumerator ShowIntro()
    {
        _isShowingIntro = true;
        InputEvents.GetInstance().OnInputActivate?.Invoke(false);

        CameraEffects.FadeInstant(1);

        intro.gameObject.SetActive(true);

        CameraEffects.Fade(0, 1, 1);

        yield return new WaitForSeconds(7);

        CameraEffects.Fade(1, 1, 0);

        yield return new WaitForSeconds(1);

        intro.gameObject.SetActive(false);

        CameraEffects.Fade(0, 2, 0);

        InputEvents.GetInstance().OnInputActivate?.Invoke(true);
        _isShowingIntro = false;
    }


    #region SELECTIONS
    // Selections


    public void ContinueCallback()
    {
        SetState(State.Closed);
    }

    public void SwitchCallback()
    {
        InputEvents.GetInstance().OnInputSwitch?.Invoke();
        SetState(State.Closed);
    }

    public void OptionsCallback()
    {

    }
    public void BackCallback()
    {
        switch (_state)
        {
            case State.Pause:
                SetState(State.Closed);
                break;
        }
    }

    public void MainMenuCallback()
    {
        TimeManager.uiTimeScale = 1;
        SceneManager.LoadScene("Splash");
    }

    #endregion
}
