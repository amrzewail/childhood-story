using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelController : MonoBehaviour
{
    [SerializeField] [RequireInterface(typeof(IActor))] Object _darkPlayer;
    [SerializeField] [RequireInterface(typeof(IActor))] Object _lightPlayer;

    //[SerializeField] Transform darkPlayerRespawnPoint;
    //[SerializeField] Transform lightPlayerRespawnPoint;


    public IActor darkPlayer => (IActor)_darkPlayer;
    public IActor lightPlayer => (IActor)_lightPlayer;

    private bool _isDeadDark = false;
    private bool _isDeadLight = false;


    // Update is called once per frame
    void Update()
    {
        if (darkPlayer.GetActorComponent<ILightDetector>(0).isOnLight == true)
        {
            if (!_isDeadDark)
            {
                darkPlayer.GetActorComponent<IActorHealth>(0).Damage(1000);
            }
        }

        if (lightPlayer.GetActorComponent<ILightDetector>(0).isOnLight == false)
        {
            if (!_isDeadLight)
            {
                lightPlayer.GetActorComponent<IActorHealth>(0).Damage(1000);
            }
        }

        if (darkPlayer.GetActorComponent<IActorHealth>(0).IsDead())
        {
            if (!_isDeadDark)
            {
                StartCoroutine(RespawnDarkPlayer());
                _isDeadDark = true;
            }
        }
        if (lightPlayer.GetActorComponent<IActorHealth>(0).IsDead())
        {
            if (!_isDeadLight)
            {
                StartCoroutine(RespawnLightPlayer());
                _isDeadLight = true;
            }
        }
    }

    internal IEnumerator RespawnDarkPlayer()
    {
        yield return new WaitForSeconds(2);

        darkPlayer.GetActorComponent<IActorHealth>(0).Heal(darkPlayer.GetActorComponent<IActorHealth>(0).GetMaxValue());
        darkPlayer.transform.position = CheckPoint.GetActiveCheckPointPosition(0);

        yield return new WaitForSeconds(Time.deltaTime);

        _isDeadDark = false;
    }

    internal IEnumerator RespawnLightPlayer()
    {
        yield return new WaitForSeconds(2);

        lightPlayer.GetActorComponent<IActorHealth>(0).Heal(lightPlayer.GetActorComponent<IActorHealth>(0).GetMaxValue());
        lightPlayer.transform.position = CheckPoint.GetActiveCheckPointPosition(1);

        yield return new WaitForSeconds(Time.deltaTime);

        _isDeadLight = false;

    }
}
