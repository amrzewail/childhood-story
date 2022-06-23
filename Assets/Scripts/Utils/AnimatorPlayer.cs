using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorPlayer : MonoBehaviour
{
    [SerializeField] Animator _animator;

    private void Reset()
    {
        _animator = GetComponentInChildren<Animator>();
    }

    public void Play(string animation)
    {
        _animator.Play(animation);
    }
}
