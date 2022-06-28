using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using DG.Tweening;

[RequireComponent(typeof(AudioSource))]
public class SFXPlayer : MonoBehaviour
{
    [System.Serializable]
    public struct Clip
    {
        public string name;
        public AudioClip clip;
    }

    [SerializeField] Clip[] _clips;

    private AudioSource _source;

    internal void Start()
    {
        _source = GetComponent<AudioSource>();
    }

    public void Play(string clipName)
    {
        AudioClip clip = _clips.Single(x => x.name.Equals(clipName)).clip;

        _source.PlayOneShot(clip);
    }

    public void Fade()
    {
        _source.DOKill();
        _source.DOFade(0, 0.5f).onComplete += () => {
            _source.Stop();
            _source.volume = 1;
        };

    }
}
