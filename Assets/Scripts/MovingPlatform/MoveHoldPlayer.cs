using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveHoldPlayer : MonoBehaviour 
{

    public void TriggerEnter(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            col.transform.SetParent(this.transform);
        }
    }
    public void TriggerExit(Collider col)
    {
        if (col.GetComponent<IActor>() != null)
        {
            col.transform.SetParent(null);
        }
    }
}