using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorGameTime : MonoBehaviour
{

    [SerializeField] Animator _animator;

    private void Reset()
    {
        _animator = GetComponentInChildren<Animator>();
    }

    private void Update()
    {
        _animator.speed = TimeManager.gameSpeed;
    }
}
