using System.Linq;
using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorInteractable : MonoBehaviour,IInteractable
{
    [SerializeField]private Transform pivot;
    [SerializeField]private Transform particle;
    [SerializeField]private MirrorInteractable mirror;
    private bool caninteract = true, iscomplete = false;
    [SerializeField]private float speed;
    private Vector3 originalPos;

    // Update is called once per frame
    public void Interact(IDictionary<string, object> data)
    {
        

        Vector3 eulerRotation = transform.rotation.eulerAngles;
        if (pivot == null || mirror == null) { return; }

        IActor actor = (IActor)data["actor"];
        StartCoroutine(TimeDelay(data));
       
        //actor.transform.position = mirror.pivot.position;
       
        actor.transform.rotation = Quaternion.Euler(eulerRotation.x, 90+eulerRotation.y, eulerRotation.z);
        //actor.gameObject.SetActive(true);
        Debug.Log("Mirror accessed by" + ((IActor)data["actor"]).transform.name);
        caninteract = false;
        iscomplete = true;
        CanInteract();
        IsComplete();
        //Debug.Log("can interact : " + CanInteract());
        //Debug.Log("is complete : " + IsComplete());


    }
    private void Awake()
    {
        //originalPos = particle.position;
    }
    private IEnumerator TimeDelay(IDictionary<string, object> data)
    {

        IActor actor = (IActor)data["actor"];
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);
        //Vector3 a = particle.transform.position;
        //Vector3 b = mirror.transform.position;
        particle.gameObject.SetActive(true);
        //particle.transform.position = Vector3.Lerp(a, b, t);
        Vector3 test = new Vector3(2.5f, 0, 0.038f);
        Debug.Log("particle first mirror position "+ test);
        particle.transform.position = Vector3.MoveTowards(test, mirror.transform.position, 2f * Time.deltaTime);
        yield return new WaitForSeconds(3);
        particle.transform.position = originalPos;
        Debug.Log("last position is the first one" + particle.transform.position);
        particle.gameObject.SetActive(false);
        actor.transform.position = mirror.pivot.position;
        actor.transform.gameObject.GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = true);


        //transform.GetComponent<Renderer>().material.color = Color.red;
    }
    private void OnDrawGizmos()
    {
        if (!mirror) return;
        Gizmos.DrawLine(transform.position, mirror.pivot.position);
    }

    public bool CanInteract() => caninteract;

   

    public bool IsComplete() => iscomplete;

    // Start is called before the first frame update
  
}
