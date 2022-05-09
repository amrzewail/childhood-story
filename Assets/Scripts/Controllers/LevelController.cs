using Characters;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class LevelController : MonoBehaviour
{


    internal void Start()
    {
        RespawningSystem.GetInstance().RespawnPlayers();
    }


}

