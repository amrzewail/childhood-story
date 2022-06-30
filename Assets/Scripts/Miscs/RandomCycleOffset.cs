using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomCycleOffset : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        GetComponent<Animator>().SetFloat("Cycle Offset", UnityEngine.Random.Range(0f, 1f));

    }
}
