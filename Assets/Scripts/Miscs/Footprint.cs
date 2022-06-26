using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Footprint : MonoBehaviour
{
    [SerializeField] ParticleSystem lightEffect;
    [SerializeField] ParticleSystem darkEffect;

    private int _lastPlayerIndex = -1;
    private IActor _lastPlayer;

    private static List<Footprint> _footprints = new List<Footprint>();

    private void Awake()
    {
        if (_footprints == null) _footprints = new List<Footprint>();

        _footprints.Add(this);


        lightEffect = Instantiate(lightEffect.gameObject, transform).GetComponent<ParticleSystem>();
        lightEffect.transform.localPosition = Vector3.zero;
        lightEffect.Stop();

        darkEffect = Instantiate(darkEffect.gameObject, transform).GetComponent<ParticleSystem>();
        darkEffect.transform.localPosition = Vector3.zero;
        darkEffect.Stop();
    }

    private void OnDestroy()
    {
        _footprints.Remove(this);
    }


    private void OnTriggerEnter(Collider other)
    {
        IActor actor = null;
        if ((actor = other.GetComponent<IActor>()) != null)
        {
            int id = actor.GetActorComponent<IActorIdentity>().characterIdentifier;


            switch (id)
            {
                case 0:
                    lightEffect.Stop();

                    if(_lastPlayerIndex == 1)
                    {
                        KillPlayer(1);
                    }

                    darkEffect.Play();

                    _lastPlayerIndex = 0;
                    break;
                case 1: 
                    darkEffect.Stop(); 
                    if (_lastPlayerIndex == 0)
                    {
                        KillPlayer(0);
                    }
                    lightEffect.Play();

                    _lastPlayerIndex = 1;
                    break;

            }

            if (id < 2) _lastPlayer = actor;

        }
    }

    private void KillPlayer(int index)
    {
        foreach(var footprint in _footprints)
        {
            if(footprint._lastPlayerIndex == index)
            {

                if(_lastPlayer != null)
                {
                    footprint._lastPlayer.GetActorComponent<IActorHealth>().Damage(1000);
                }

                footprint.darkEffect.Stop();
                footprint.lightEffect.Stop();
                footprint._lastPlayer = null;

            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        
    }



}
