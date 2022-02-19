using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorInteractable : MonoBehaviour,IInteractable
{
    [SerializeField] private Transform pivot = null;

    // Update is called once per frame
    public void Interact(IDictionary<string, object> data)
    {
        Vector3 eulerRotation = transform.rotation.eulerAngles;
        if (pivot == null) { return; }
        IActor actor = (IActor)data["actor"];
        actor.transform.position = pivot.position;
       
        actor.transform.rotation = Quaternion.Euler(eulerRotation.x, 90+eulerRotation.y, eulerRotation.z);
        Debug.Log("Mirror accessed by" + ((IActor)data["actor"]).transform.name);



    }
    public bool CanInteract()
    {
        //code
        return true;
    }

   

    public bool IsComplete()
    {
        //code
        return true ;
    }

    // Start is called before the first frame update
  
}
