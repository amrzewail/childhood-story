using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BookInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] float timeStopDuration = 5;
    [SerializeField] float cooldown = 10;

    private bool canInteract = false;
    private bool isComplete = false;

    internal void Start()
    {
        canInteract = true;
        isComplete = true;
    }

    public void Interact(IDictionary<string, object> data) 
    {
        IActor actor = (IActor)data["actor"];


        if (actor.GetActorComponent<IActorIdentity>(0).characterIdentifier == 1) // is light ?
        {
            return;
        }

        Debug.Log(((IActor)data["actor"]).transform.name);

        StartCoroutine(Interaction(actor));

    }

    public bool IsComplete()
    {
        return isComplete;
    }
    public bool CanInteract() 
    {
        return canInteract;
    }

    private IEnumerator Interaction(IActor actor)
    {
        canInteract = false;
        isComplete = true;

        TimeManager.gameSpeed = 0.05f;

        yield return new WaitForSeconds(timeStopDuration);

        TimeManager.gameSpeed = 1;

        yield return new WaitForSeconds(cooldown);

        isComplete = true;
        canInteract = true;

    }
}
