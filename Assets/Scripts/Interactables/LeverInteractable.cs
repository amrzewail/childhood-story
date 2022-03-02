using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class LeverInteractable : MonoBehaviour, IInteractable
{
    //[SerializeField]private Transform pivot_rotation_angle;
    [SerializeField]private float timedelay;
    //[SerializeField]private float maximumrotation = 50f;
    [SerializeField]private bool oneTimeOnly;
    private bool canInteract, isComplete;
    private Animator anim;
    public UnityEvent OnTriggerLever;

    void Start()
    {
        this.anim = this.GetComponent<Animator>();
        canInteract = true;
        isComplete = false;
        //pivot_rotation_angle.localEulerAngles = new Vector3(-maximumrotation, 0, 0);
    }
    private void Update()
    {
        if (CanInteract() == false)
        {
            
            //pivot_rotation_angle.localEulerAngles = Vector3.MoveTowards(pivot_rotation_angle.localEulerAngles,new Vector3 (maximumrotation,0,0),  ((maximumrotation*2)/timedelay)* Time.deltaTime);

            //pivot_rotation_angle.Rotate(pivot_rotation_angle.right * ((maximumrotation * 2) / timedelay) * Time.deltaTime);
           
        }
        

    }
    public void Interact(IDictionary<string, object> data)
    {
        OnTriggerLever.Invoke();
        //if (pivot_rotation_angle == null) { return; }
        isComplete = true;
        canInteract = false;
        if(!oneTimeOnly){ StartCoroutine(TimeDelay()); }

        
        this.anim.SetTrigger("Down");
        Debug.Log("Lever toggled ");

    }
    private IEnumerator TimeDelay()
    {

        yield return new WaitForSeconds(timedelay);
        ResetLever();
        
    }
    //private IEnumerator TimeDelay(IDictionary<string, object> data)
    //{

    //}
    public void ResetLever()
    {
        if(canInteract == false)
        { 
            this.anim.SetTrigger("Up");
            canInteract = true;
            StopAllCoroutines();
        }
    }
    public bool CanInteract() => canInteract;

    public bool IsComplete() => isComplete;





}
