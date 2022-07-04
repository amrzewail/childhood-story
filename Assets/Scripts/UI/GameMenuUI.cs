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
        Pause,
        Controls
    }

    [Header("Pause")]
    public GameObject pause;


    [Header("Controls")]
    public GameObject controls;
    public Transform controlLayouts;

    [Space]
    public Selections pauseSelections;
    public GameObject intro;

    private State _state = State.Closed;

    private bool _didChangeState = false;
    private bool _isShowingIntro = false;
    private int _currentControlLayout = 0;


    private void Start()
    {
        InputUIEvents.GetInstance().Start += StartCallback;
        InputUIEvents.GetInstance().Up += UpCallback;
        InputUIEvents.GetInstance().Down += DownCallback;
        InputUIEvents.GetInstance().Right += RightCallback;
        InputUIEvents.GetInstance().Left += LeftCallback;
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
        InputUIEvents.GetInstance().Right -= RightCallback;
        InputUIEvents.GetInstance().Left -= LeftCallback;
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
                controls.SetActive(false);
                InputEvents.GetInstance().OnInputActivate?.Invoke(true);

                TimeManager.uiTimeScale = 1f;

                break;

            case State.Pause:
                pause.SetActive(true);
                controls.SetActive(false);
                InputEvents.GetInstance().OnInputActivate?.Invoke(false);

                TimeManager.uiTimeScale = 0.0001f;
                break;

            case State.Controls:
                pause.SetActive(false);
                controls.SetActive(true);
                InputEvents.GetInstance().OnInputActivate?.Invoke(false);

                TimeManager.uiTimeScale = 0.0001f;

                _currentControlLayout = 0;
                for (int i = 0; i < controlLayouts.childCount; i++)
                {
                    controlLayouts.GetChild(i).gameObject.SetActive(i == _currentControlLayout);
                }
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

            case State.Controls:
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
    public void RightCallback()
    {
        if (_state == State.Closed) return;

        switch (_state)
        {
            case State.Controls:
                _currentControlLayout++;
                _currentControlLayout = _currentControlLayout % controlLayouts.childCount;
                for (int i = 0; i < controlLayouts.childCount; i++)
                {
                    controlLayouts.GetChild(i).gameObject.SetActive(i == _currentControlLayout);
                }
                break;
        }
    }

    public void LeftCallback()
    {
        if (_state == State.Closed) return;

        switch (_state)
        {
            case State.Controls:
                _currentControlLayout--;
                _currentControlLayout = _currentControlLayout < 0 ? controlLayouts.childCount - 1 : _currentControlLayout;
                for (int i = 0; i < controlLayouts.childCount; i++)
                {
                    controlLayouts.GetChild(i).gameObject.SetActive(i == _currentControlLayout);
                }
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

            case State.Controls:
                SetState(State.Pause);
                break;
        }
    }
    public void BackCallback()
    {
        switch (_state)
        {
            case State.Pause:
                SetState(State.Closed);
                break;

            case State.Controls:
                SetState(State.Pause);
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

    public void ControlsCallback()
    {
        SetState(State.Controls);
    }

    public void OptionsCallback()
    {

    }


    public void MainMenuCallback()
    {
        TimeManager.uiTimeScale = 1;
        SceneManager.LoadScene("Splash");
    }

    #endregion
}
