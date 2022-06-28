using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGMArea : MonoBehaviour
{
    [SerializeField] AudioClip BGM;

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.CompareTag("MainCamera"))
        {
            BGMPlayer.GetInstance().Play(BGM);

        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("MainCamera"))
        {
            BGMPlayer.GetInstance().Stop();

        }
    }
}
