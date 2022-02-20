using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerButton : MonoBehaviour
{
    [SerializeField]
    GameObject renderer;
    [SerializeField]
    float pressDistance=0.2f;

    public void ButtonDown(Collider col)
    {
        if( col.GetComponent<IActor>() != null)
            renderer.transform.Translate(Vector3.down * pressDistance);
    }
    public void ButtonUp(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
            renderer.transform.Translate(Vector3.up * pressDistance);
    }
}
