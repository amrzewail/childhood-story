using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorInteractable : MonoBehaviour,IInteractable
{
    [SerializeField]private Transform pivot;
    [SerializeField]private MirrorInteractable mirror;
    private bool caninteract = true, iscomplete = false;
    private bool froze = false;
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

    private IEnumerator TimeDelay(IDictionary<string, object> data)
    {
        
        IActor actor = (IActor)data["actor"];
        actor.transform.gameObject.SetActive(false);
        yield return new WaitForSeconds(2);
        
        actor.transform.position = mirror.pivot.position;
        actor.transform.gameObject.SetActive(true);

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
