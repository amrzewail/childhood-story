using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BookInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] float timeStopDuration = 5;
    [SerializeField] float cooldown = 10;
    [SerializeField] ParticleSystem effect;
    [SerializeField] ParticleSystem cooldownEffect;

    private bool canInteract = false;
    private bool isComplete = false;

    [SerializeField] UnityEvent OnBookStart;
    [SerializeField] UnityEvent OnBookEnd;


    internal void Start()
    {
        canInteract = true;
        isComplete = true;

        effect.Stop();
        cooldownEffect.Stop();
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
        OnBookStart?.Invoke();

        canInteract = false;
        isComplete = true;

        effect.Play();
        cooldownEffect.Play();

        TimeManager.gameSpeed = 0.05f;

        yield return new WaitForSeconds(timeStopDuration);

        effect.Stop();

        TimeManager.gameSpeed = 1;

        OnBookEnd?.Invoke();

        yield return new WaitForSeconds(cooldown);

        cooldownEffect.Stop();

        isComplete = true;
        canInteract = true;

    }
}
