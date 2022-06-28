using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Characters
{
    public class CharacterAnimator : MonoBehaviour, IAnimator
    {
        private const float BLEND_TIME = 0.2f;

        private Animator _animator;

        private AnimatorLayer[] _layers;

        public string[] noBlendTimeAnimations;

        private void Awake()
        {
            if(!_animator) _animator = GetComponent<Animator>();
            _layers = new AnimatorLayer[_animator.layerCount];
            for (int i = 0; i < _layers.Length; i++) _layers[i] = new AnimatorLayer();
        }

        private void Start()
        {

        }

        private void Update()
        {
            for (int i = 0; i < _layers.Length; i++)
            {
                _layers[i].Update(_animator);
            }
        }

        public void ResetRootMotion(IActor actor)
        {
            //SetRootMotion(false);

            actor.transform.eulerAngles = _animator.transform.eulerAngles;
            actor.transform.position = _animator.transform.position;

            _animator.transform.localPosition = Vector3.zero;
            _animator.transform.localEulerAngles = Vector3.zero;

        }

        public void SetRootMotion(bool value)
        {
            _animator.applyRootMotion = value;
        }

        public void Play(int layer, string stateName)
        {
            Play(layer, stateName, 1, false);
        }

        public void Play(int layer, string stateName, float speed, bool mirror)
        {
            if (layer >= _layers.Length) return;
            var animLayer = _layers[layer];
            animLayer.Play(_animator, layer, noBlendTimeAnimations, stateName, speed, mirror);
        }

        public bool IsPlaying(int layer, string stateName)
        {
            if (layer >= _layers.Length) return false;

            return _layers[layer].IsPlaying(stateName);
        }

        public bool IsAnimationFinished(int layer)
        {
            if (layer >= _layers.Length) return false;

            return _layers[layer].isAnimationFinished;
        }

        public float GetNormalizedTime(int layer)
        {
            if (layer >= _layers.Length) return 0;

            return _layers[layer].normalizedTime;
        }
        public void SetNormalizedTime(int layer, float time)
        {
            if (layer >= _layers.Length) return;

            _layers[layer].normalizedTime = time;
        }

        public string GetCurrentAnimation(int layer)
        {
            if (layer >= _layers.Length) return null;

            return _layers[layer].currentAnimation;
        }

        public void Pause()
        {
            _animator.speed = 0;
        }

        public void Unpause()
        {
            _animator.speed = 1;
        }

        public class AnimatorLayer
        {
            private AnimatorStateInfo _stateInfo;
            private float _currentSpeed;
            private bool _currentMirror;
            private bool _changedAnimation;

            public float normalizedTime;
            public string currentAnimation;
            public bool isAnimationFinished;

            public void Update(Animator animator)
            {
                if(_changedAnimation && normalizedTime < 1)
                {
                    _changedAnimation = false;
                }
                if (!_changedAnimation) isAnimationFinished = normalizedTime == 1;

            }

            public void Play(Animator animator, int layer, string[] noBlendTimeAnimations, string stateName, float speed, bool mirror)
            {
                if (!IsPlaying(stateName) || isAnimationFinished || !animator.GetCurrentAnimatorStateInfo(layer).IsName(currentAnimation))
                {
                    animator.CrossFadeInFixedTime(stateName, noBlendTimeAnimations.Contains(stateName) ? 0 : BLEND_TIME);
                    animator.SetFloat("Speed", speed);
                    _currentSpeed = speed;
                    animator.SetBool("Mirror", mirror);
                    _currentMirror = mirror;
                    currentAnimation = stateName;
                    normalizedTime = 0;
                    isAnimationFinished = false;
                    _changedAnimation = true;
                }
                else
                {
                    if (speed != _currentSpeed)
                    {
                        animator.SetFloat("Speed", speed);
                        _currentSpeed = speed;
                    }
                    if (mirror != _currentMirror)
                    {
                        animator.SetBool("Mirror", _currentMirror);
                        _currentMirror = mirror;
                    }
                }

            }

            public bool IsPlaying(string stateName)
            {
                return currentAnimation == stateName;
            }

        }
    }
}