using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeverInteractable : MonoBehaviour, IInteractable
{
    [SerializeField]private Transform pivot_rotation_angle;
    [SerializeField]private float timedelay;
    [SerializeField]private float maximumrotation = 50f; 
    private bool canInteract, isComplete;
    

    void Start()
    {
        canInteract = true;
        isComplete = false;
        pivot_rotation_angle.localEulerAngles = new Vector3(-maximumrotation, 0, 0);
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
        if(pivot_rotation_angle == null) { return; }
        isComplete = false;
        canInteract = false;
        StartCoroutine(TimeDelay());
        
        Debug.Log("Lever toggled ");


    }
    private IEnumerator TimeDelay()
    {
        isComplete = true;

        yield return new WaitForSeconds(timedelay);
        canInteract = true;
        
    }
    //private IEnumerator TimeDelay(IDictionary<string, object> data)
    //{

    //}

    public bool CanInteract() => canInteract;

    public bool IsComplete() => isComplete;





}
