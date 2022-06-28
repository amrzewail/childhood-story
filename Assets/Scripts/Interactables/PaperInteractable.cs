using Characters;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class PaperInteractable : MonoBehaviour, IInteractable
{

    [SerializeField] Transform _interactOrigin;
    [SerializeField] Animator _animator;

    private bool _isComplete = true;
    private bool _canInteract = true;

    private bool _shouldCompleteInteraction;

    public void Interact(IDictionary<string, object> data) {
        
        IActor actor = (IActor)data["actor"];

        if (actor.GetActorComponent<IActorIdentity>().characterIdentifier == 1)
        {

            StartCoroutine(OnInteract(actor));

            StreetLevel.Instance.OnCompleteInteractions.AddListener(CompleteInteractionsCallback);
        }
    }

    private void CompleteInteractionsCallback()
    {
        _shouldCompleteInteraction = true;
    }

    private IEnumerator OnInteract(IActor actor)
    {

        _isComplete = false;
        _canInteract = false;

        actor.transform.GetComponentInChildren<Rigidbody>().isKinematic = true;

        actor.transform.DOMove(_interactOrigin.position, 0.15f);
        actor.transform.DORotate(_interactOrigin.eulerAngles, 0.15f);

        yield return new WaitForSeconds(0.15f);

        actor.GetActorComponent<IAnimator>().Play(0, "Grab Paper");

        yield return new WaitForSeconds(1.7f);

        GetComponentsInChildren<Renderer>().ToList().ForEach(x => x.enabled = false);

        yield return new WaitForSeconds(5f - 1.7f);

        StreetLevel.Instance.SetPaperInteractionStarted();

        yield return new WaitUntil(() => _shouldCompleteInteraction);

        actor.GetActorComponent<IAnimator>().Play(0, "Throw Paper");

        yield return new WaitForSeconds(2.05f);


        actor.transform.GetComponentInChildren<Rigidbody>().isKinematic = false;
        _isComplete = true;
        _canInteract = false;

    }

    public bool IsComplete()
    {
        return _isComplete;
    }
    public bool CanInteract() 
    {
        return _canInteract;
    }
}
