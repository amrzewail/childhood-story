using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayParticles : MonoBehaviour
{
    [SerializeField] List<ParticleSystem> _targets;

    public void Play()
    {
        _targets.ForEach(x => x.Play());
    }

    public void Stop()
    {
        _targets.ForEach(x => x.Stop());
    }
}
