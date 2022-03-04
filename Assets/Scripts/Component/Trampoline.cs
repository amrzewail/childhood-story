using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Trampoline : MonoBehaviour
{
    [SerializeField] float distance = 100f;

    public UnityEvent OnShoot;

    public void OnTrampolineDown(Collider col)
    {
        Rigidbody rb = col.GetComponent<Rigidbody>();
        if (rb != null)
        {
            rb.velocity = transform.up * distance / rb.mass;// new Vector3(rb.velocity.x, distance, rb.velocity.z);
            OnShoot?.Invoke();
        }
    }
}
