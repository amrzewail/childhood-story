using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGMPlayer : Singleton<BGMPlayer>
{

    [SerializeField] DoubleAudioSource _source;

    private AudioClip _clip;

    private int _queueCount = 0;

    public void Play(AudioClip clip)
    {
        if (clip.name.Equals(Current()))
        {
            _queueCount++;
        }
        else
        {
            _queueCount = 1;
            _clip = clip;
            _source.CrossFade(clip, 1, 1f, 0);
        }
    }

    public void Stop()
    {
        _queueCount--;

        if(_queueCount <= 0)
        {
            _clip = null;
            _source.CrossFade(null, 1, 1, 0);
        }
    }

    public string Current()
    {
        if (!_clip) return "";
        return _clip.name;
    }

}
