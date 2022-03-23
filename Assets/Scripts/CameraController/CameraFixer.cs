using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFixer : MonoBehaviour
{

    [SerializeField] Transform targetCameraTransform;

    private List<int> _enteredPlayers;

    private ICamera _camera;
    private Vector3 _cameraInitialPosition;
    private Vector3 _cameraInitialEuler;

    private float _lerpValue;

    private bool _isActive = false;
    private static int _currentActiveFixers = 0;

    void Start()
    {
        _enteredPlayers = new List<int>();

        _camera = this.FindInterfaceOfType<ICamera>();
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

        if(_enteredPlayers.Count >= 2)
        {
            _lerpValue += Time.deltaTime * 2;
            _lerpValue = Mathf.Clamp01(_lerpValue);

            _camera.transform.position = Vector3.Lerp(_cameraInitialPosition, targetCameraTransform.position, _lerpValue);
            _camera.transform.eulerAngles = Vector3.Lerp(_cameraInitialEuler, targetCameraTransform.eulerAngles, _lerpValue);

        }
    }

    private void OnTriggerEnter(Collider other)
    {
        IActor actor;
        if((actor = other.GetComponent<IActor>()) != null)
        {
            var id = actor.GetActorComponent<IActorIdentity>(0);

            if(id != null && id.characterIdentifier <= 1)
            {
                if (!_enteredPlayers.Contains(id.characterIdentifier))
                {
                    _enteredPlayers.Add(id.characterIdentifier);
                    if(_camera != null && _enteredPlayers.Count >= 2)
                    {
                        _currentActiveFixers++;
                        _isActive = true;
                        _camera.Enable(false);
                        _cameraInitialPosition = _camera.transform.position;
                        _cameraInitialEuler = _camera.transform.eulerAngles;
                        _lerpValue = 0;
                    }
                }
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        IActor actor;
        if ((actor = other.GetComponent<IActor>()) != null)
        {
            var id = actor.GetActorComponent<IActorIdentity>(0);

            if (id != null && id.characterIdentifier <= 1)
            {
                if (_enteredPlayers.Contains(id.characterIdentifier))
                {
                    _enteredPlayers.Remove(id.characterIdentifier);
                    if (_enteredPlayers.Count < 2 && _camera != null)
                    {
                        _currentActiveFixers--;
                        _isActive = false;
                        if (_currentActiveFixers <= 0)
                        {
                            _camera.Enable(true);
                        }
                    }
                }
            }
        }
    }

}
