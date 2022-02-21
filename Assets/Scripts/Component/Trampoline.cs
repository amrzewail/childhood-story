using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trampoline : MonoBehaviour
{
    [SerializeField] float distance = 100f;
    IActor actor;

    public void OnTrampolineDown(Collider col)
    {
        actor = col.GetComponent<IActor>();
        if (actor != null)
            actor.transform.GetComponent<Rigidbody>().AddForce(transform.up * distance);
    }
}
