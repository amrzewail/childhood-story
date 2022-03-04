using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IAnimator : IComponent
{
    public void Play(int layer, string stateName);

    public void Play(int layer, string stateName, float speed, bool mirror);

    public bool IsPlaying(int layer, string stateName);

    public bool IsAnimationFinished(int layer);

    public float GetNormalizedTime(int layer);

    public void SetNormalizedTime(int layer, float time);

    public string GetCurrentAnimation(int layer);
}