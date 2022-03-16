using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DarkCloudAbility : MonoBehaviour, IAbility
{
    //this is property canPerform
    private bool canPerform = true;
    //this is property isComplete
    private bool isComplete = true;
    public GameObject actor;
    public LightDetector DarkLightDectector;

    //Start happens at the start of the game
    private void Start()
    {
        canPerform = true;
        isComplete = true;
    }

    private void Update()
    {

    }

    public bool CanPerform()
    {
        return canPerform;
    }

    public bool IsComplete()
    {
        return isComplete;
    }

    //Here you perform the ability
    public void Perform()
    {

        StartCoroutine(StartAbility());
    }

    IEnumerator StartAbility()
    {
        canPerform = false;
        isComplete = true;

        DarkLightDectector.enabled = false;



        Debug.Log("Perform new ability!!");

        //This is a cooldown for the ability
        yield return new WaitForSeconds(2);

        Debug.Log("Ability is available");

        canPerform = true;
        isComplete = true;

        DarkLightDectector.enabled = true;
        yield return new WaitForSeconds(4);
        Debug.Log("Ability is in cooldown");
    }
}
