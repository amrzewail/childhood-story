using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFixer : MonoBehaviour
{

    [SerializeField] Transform targetCameraTransform;

    private int _enteredPlayers = 0;

    private ICamera _camera;
    private Vector3 _cameraInitialPosition;
    private Quaternion _cameraInitialEuler;

    private float _lerpValue;

    private bool _isActive = false;
    private static int _currentActiveFixers = 0;

    IEnumerator Start()
    {
        while (_camera == null)
        {
            _camera = this.FindInterfaceOfType<ICamera>();

            yield return null;
        }
    }

    private void OnDestroy()
    {
        if (_isActive)
        {
            _currentActiveFixers--;
            if (_currentActiveFixers <= 0)
            {
                _camera.Enable(true);
            }
        }
    }

    private void LateUpdate()
    {
        if (_camera == null) return;

        if(_isActive)
        {
            _lerpValue += Time.deltaTime * 2;
            _lerpValue = Mathf.Clamp01(_lerpValue);


            Quaternion targetEuler = targetCameraTransform.rotation;

            Debug.Log($"Init:{_cameraInitialEuler} target:{targetEuler}");

            _camera.transform.position = Vector3.Lerp(_cameraInitialPosition, targetCameraTransform.position, _lerpValue);
            _camera.transform.rotation = Quaternion.Lerp(_cameraInitialEuler, targetEuler, _lerpValue);

        }
    }

    public void OnPlayerEnter()
    {
        _enteredPlayers++;
        if (_enteredPlayers >= 2)
        {
            _currentActiveFixers++;

            StartCoroutine(PlayerEnterCoroutine());
        }
    }

    public void OnPlayerExit()
    {
        _enteredPlayers--;
        if (_enteredPlayers < 2)
        {
            _currentActiveFixers--;
            _isActive = false;

            if (_currentActiveFixers <= 0)
            {
                _currentActiveFixers = 0;
                StartCoroutine(PlayerExitCoroutine());
            }
        }
    }

    private IEnumerator PlayerEnterCoroutine()
    {
        yield return new WaitUntil(() => _camera != null);

        _isActive = true;
        _camera.Enable(false);
        _cameraInitialPosition = _camera.transform.position;


        _cameraInitialEuler = _camera.transform.rotation;

        _lerpValue = 0;
    }

    private IEnumerator PlayerExitCoroutine()
    {
        yield return new WaitUntil(() => _camera != null);

        _camera.Enable(true);
        
    }
}
