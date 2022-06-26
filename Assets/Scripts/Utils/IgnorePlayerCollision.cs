using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class IgnorePlayerCollision : MonoBehaviour
{
    List<Collider> players = null;

    IEnumerator Start()
    {
        
        //while(players == null)
        //{
        //    GameObject[] gameObjects = GameObject.FindGameObjectsWithTag("Player");

        //    if(gameObjects != null)
        //    {
        //        players = new List<Collider>();
        //        gameObjects.ToList().ForEach(x => players.Add(x.GetComponent<Collider>()));
        //    }

        //    yield return null;
        //}

        for(int i = 0; i < 32; i++)
        {
            Physics.IgnoreLayerCollision(12, i);
        }


        yield return null;

        //Collider col = GetComponent<Collider>();

        //players.ForEach(x => Physics.IgnoreCollision(x, col, true));
    }
}
