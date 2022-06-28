using Characters;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class DarkRoomCutscene : MonoBehaviour, IInteractable
{
    [SerializeField] int _alllowedPlayer;
    [SerializeField] Transform _interactOrigin;
    [SerializeField] Transform _destination1;
    [SerializeField] Transform _destination2;
    [SerializeField] Transform _destination3;

    [SerializeField] SpriteRenderer _roof;

    [Header("Door")]
    [SerializeField] Animator _animator;

    [Header("Parent")]
    [SerializeField] Transform _parent;

    [Header("Cat")]
    [SerializeField] Transform _cat;

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
            HomeLevel.GetInstance().OnUniteCutsceneCompleted.AddListener(UnityCutsceneCompleteCallback);
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

        yield return new WaitForSeconds(0.15f); //0.15

        // girl opens the door

        actor.GetActorComponent<IAnimator>().Play(0, "Start Open Door");

        yield return new WaitForSeconds(0.25f); //0.35

        if(_alllowedPlayer == 0) HomeLevel.GetInstance().SetDarkDoorInteracted();
        else if (_alllowedPlayer == 1)  HomeLevel.GetInstance().SetLightDoorInteracted();

        yield return new WaitUntil(() => _shouldStartOpenDoors);


        actor.GetActorComponent<IAnimator>().Play(0, "Opening Door");

        yield return new WaitForSeconds(2.33f); //
            
        _animator.Play("apartment-door1-open");

        _roof.DOFade(0, 1);

        // girl walks to inside the room

        actor.GetActorComponent<IAnimator>().Play(0, "Walk");

        actor.transform.DOMove(_destination1.position, 3).SetEase(Ease.Linear);

        yield return new WaitForSeconds(3);


        // parent walks in and girl turns left



        actor.GetActorComponent<IAnimator>().Play(0, "Left Turn");
        actor.GetActorComponent<IAnimator>().SetRootMotion(true);



        _parent.gameObject.SetActive(true);
        _parent.GetComponentInChildren<Animator>().Play("Walk");

        _parent.transform.DOMove(_destination2.position, 3).SetEase(Ease.Linear);


        yield return new WaitForSeconds(3);

        // parent gestures out

        _parent.GetComponentInChildren<Animator>().CrossFadeInFixedTime("Angry Point", 0.2f);

        yield return new WaitForSeconds(3);

        // cat walks out the room

        _cat.DOMove(_destination3.position, 2).SetEase(Ease.Linear);
        _cat.GetComponentInChildren<Animator>().CrossFadeInFixedTime("walk", 0.2f);

        yield return new WaitForSeconds(1);

        // cat disappears
        _cat.GetComponentInChildren<ParticleSystem>().Play();

        yield return new WaitForSeconds(0.5f);

        _cat.GetComponentInChildren<Renderer>().enabled = false;

        // the girl turns to her mother
        actor.GetActorComponent<IAnimator>().Play(0, "Left Turn");


        yield return new WaitForSeconds(1);


        //girl reaching out

        actor.GetActorComponent<IAnimator>().Play(0, "Reaching Out");

        yield return new WaitForSeconds(3);

        // the mother disappears

        _parent.GetComponentInChildren<ParticleSystem>().Play();

        yield return new WaitForSeconds(0.75f);

        _parent.Find("Animator").gameObject.SetActive(false);

        yield return new WaitForSeconds(3);

        //actor.transform.GetComponentInChildren<Rigidbody>().isKinematic = false;
        //_isComplete = true;
        //_canInteract = false;

        HomeLevel.GetInstance().SetDarkRoomCutsceneComplete();
    }

    public bool IsComplete()
    {
        return _isComplete;
    }
    public bool CanInteract()
    {
        return _canInteract;
    }

    private void UnityCutsceneCompleteCallback()
    {
        _isComplete = true;
        _canInteract = false;

    }

}
