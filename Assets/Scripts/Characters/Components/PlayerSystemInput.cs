using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;



public class PlayerSystemInput : MonoBehaviour, IInput
{
    [SerializeField] int inputIndex;
    public Vector2 axis { get; private set; }

    public Vector2 absAxis { get; private set; }

    public Vector2 aimAxis { get; private set; }

    private bool _isInteract = false;
    private bool _isAbility = false;
    private bool _isDash = false;
    private bool _isShoot = false;

    private bool _isInteractUp = false;
    private bool _isAbilityUp = false;
    private bool _isShootUp = false;

    internal void Start()
    {
        InputEvents.instance.OnMove += MoveCallback;
        InputEvents.instance.OnAim += AimCallback;
        InputEvents.instance.OnInteract += InteractCallback;
        InputEvents.instance.OnInteractUp += InteractUpCallback;
        InputEvents.instance.OnAbility += AbilityCallback;
        InputEvents.instance.OnDash += DashCallback;
        InputEvents.instance.OnShoot += ShootCallback;
    }
    internal void LateUpdate()
    {
        _isInteractUp = false;
        _isAbilityUp = false;
        _isShootUp = false;

        _isInteract = false;
        _isAbility = false;
        _isDash = false;
        _isShoot = false;

    }

    private Vector2 TransformAxis(Vector2 a)
    {
        float radians = -Camera.main.transform.eulerAngles.y * Mathf.PI / 180;
        float cos = Mathf.Cos(radians), sin = Mathf.Sin(radians);
        var ax = a;
        ax.x = cos * a.x - sin * a.y;
        ax.y = cos * a.y + sin * a.x;
        return ax;
    }

    private void MoveCallback(int index, Vector2 a)
    {
        if(index == inputIndex)
        {
            axis = TransformAxis(a);
            if (axis.magnitude != 0)
            {
                absAxis = axis;
            }
        }
    }

    private void AimCallback(int index, Vector2 a)
    {
        if(index == inputIndex)
        {
            a = TransformAxis(a);
            if(a.magnitude != 0)
            {
                aimAxis = a;
            }
        }
    }

    private void InteractCallback(int index)
    {
        if (index == inputIndex)
        {
            _isInteract = true;
        }
    }
    private void InteractUpCallback(int index)
    {
        if (index == inputIndex)
        {
            _isInteractUp = true;
        }
    }

    private void DashCallback(int index)
    {
        if(index == inputIndex)
        {
            _isDash = true;
        }
    }

    private void AbilityCallback(int index)
    {
        if (index == inputIndex)
        {
            _isAbility = true;
        }
    }
    private void ShootCallback(int index)
    {
        if (index == inputIndex)
        {
            _isShoot = true;
        }
    }

    public bool IsKeyDown(string key)
    {
        switch (key)
        {
            case "interact": return _isInteract;
            case "ability": return _isAbility;
            case "dash": return _isDash;
            case "shoot": return _isShoot;

        }
        return false;
    }

    public bool IsKeyUp(string key)
    {
        switch (key)
        {
            case "interact": return _isInteractUp;
            //ability
            //shoot
        }
        return false;
    }
}
