using Characters;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] int _alllowedPlayer;
    [SerializeField] Transform _interactOrigin;
    [SerializeField] Animator _animator;

    private bool _isComplete = true;
    private bool _canInteract = true;

    private bool _shouldStartOpenDoors;

    public void Interact(IDictionary<string, object> data)
    {

        IActor actor = (IActor)data["actor"];

        if (actor.GetActorComponent<IActorIdentity>().characterIdentifier == _alllowedPlayer)
        {

            StartCoroutine(OnInteract(actor));

            HomeLevel.GetInstance().OnStartOpenDoors.AddListener(StartOpenDoorsCallback);

        }
    }
    private void StartOpenDoorsCallback()
    {
        _shouldStartOpenDoors = true;
    }


    private IEnumerator OnInteract(IActor actor)
    {

        _isComplete = false;
        _canInteract = false;

        actor.transform.GetComponentInChildren<Rigidbody>().isKinematic = true;
        actor.transform.DOMove(_interactOrigin.position, 0.15f);
        actor.transform.DORotate(_interactOrigin.eulerAngles, 0.15f);

        yield return new WaitForSeconds(0.15f);


        actor.GetActorComponent<IAnimator>().Play(0, "Start Open Door");

        yield return new WaitForSeconds(0.25f);

        if(_alllowedPlayer == 0) HomeLevel.GetInstance().SetDarkDoorInteracted();
        else if (_alllowedPlayer == 1)  HomeLevel.GetInstance().SetLightDoorInteracted();

        yield return new WaitUntil(() => _shouldStartOpenDoors);


        actor.GetActorComponent<IAnimator>().Play(0, "Opening Door");

        yield return new WaitForSeconds(2.33f);
            
        _animator.Play("apartment-door1-open");

        yield return new WaitForSeconds(0.66f);

        actor.GetActorComponent<IAnimator>().Play(0, "Walk");




        yield return new WaitForSeconds(3.33f);

        //actor.transform.GetComponentInChildren<Rigidbody>().isKinematic = false;
        //_isComplete = true;
        //_canInteract = false;
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
