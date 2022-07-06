using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Trampoline : MonoBehaviour
{
    [SerializeField] float distance = 100f;
    [SerializeField] Animator animator;

    public UnityEvent OnShoot;

    public void OnTrampolineDown(Collider col)
    {
        Rigidbody rb = col.GetComponent<Rigidbody>();
        if (rb != null)
        {
            if (rb.transform.position.y >= transform.position.y - 1)
            {
                //rb.position += Vector3.up * 0.51f;
                rb.velocity = transform.up * distance / rb.mass;// new Vector3(rb.velocity.x, distance, rb.velocity.z);
                OnShoot?.Invoke();

                animator.Play("Bounce");
            }
        }
    }
}
