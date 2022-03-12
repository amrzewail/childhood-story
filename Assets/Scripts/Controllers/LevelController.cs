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


    // Update is called once per frame
    void UpdateF()
    {
        if (darkPlayer.GetActorComponent<ILightDetector>(0).isOnLight == true)
        {
            darkPlayer.transform.position = CheckPoint.GetActiveCheckPointPosition(0);
        }

        if (lightPlayer.GetActorComponent<ILightDetector>(0).isOnLight == false)
        {
            lightPlayer.transform.position = CheckPoint.GetActiveCheckPointPosition(1);

        }
    }
}
