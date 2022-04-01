using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyTargeter : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Player"))
        {
            Debug.Log("Triggered");
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Debug.Log("Out of Range!!");
        }
    }
}
