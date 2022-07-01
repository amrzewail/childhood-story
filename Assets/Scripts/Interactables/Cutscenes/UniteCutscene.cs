using Characters;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class UniteCutscene : MonoBehaviour
{
    [SerializeField] AudioClip BGM;

    [SerializeField] Transform _walls;
    [SerializeField] Transform _floors;
    [SerializeField] Transform _moreFloors;


    [Header("Destinations")]
    [SerializeField] Transform _lightDestination1;
    [SerializeField] Transform _darkDestination1;

    


    // Start is called before the first frame update
    void Start()
    {
        HomeLevel.GetInstance().OnStartOpenDoors.AddListener(OpenDoorsCallback);
        HomeLevel.GetInstance().OnRoomCutsceneCompleted.AddListener(Begin);

        _floors.gameObject.SetActive(false);
        _moreFloors.gameObject.SetActive(false);
    }

    private void OpenDoorsCallback()
    {
        StartCoroutine(RunRoomsCutscene());

        ICamera camera = this.FindInterfaceOfType<ICamera>();

        float zoomValue = 1;
        DOTween.To(() => zoomValue, x => camera.Zoom(zoomValue = x), 1.25f, 6);
    }

    private IEnumerator RunRoomsCutscene()
    {

        yield return new WaitForSeconds(3);

        BGMPlayer.GetInstance().Play(BGM);
    }


    private void Begin()
    {
        StartCoroutine(RunCutscene());
    }

    private IEnumerator RunCutscene()
    {
        yield return null;

        ICamera camera = this.FindInterfaceOfType<ICamera>();

        IActor lightActor = this.FindInterfacesOfType<IActor>().ToList().Single(x => x.GetActorComponent<IActorIdentity>().characterIdentifier == 1);

        IActor darkActor = this.FindInterfacesOfType<IActor>().ToList().Single(x => x.GetActorComponent<IActorIdentity>().characterIdentifier == 0);

        lightActor.GetActorComponent<ILightDetector>().isActive = false;
        darkActor.GetActorComponent<ILightDetector>().isActive = false;

        yield return new WaitForSeconds(3);

        for(int i = 0; i < _walls.childCount; i++)
        {
            var position = _walls.GetChild(i).transform.position;
            _walls.GetChild(i).DOMove(position + Vector3.down * 10, 4);
        }

        _floors.gameObject.SetActive(true);

        for (int i = 0; i < _floors.childCount; i++)
        {
            _floors.GetChild(i).transform.position += Vector3.down * 10;
            _floors.GetChild(i).DOMove(_floors.GetChild(i).transform.position + Vector3.up * 10, 4 * UnityEngine.Random.Range(0.5f, 1.5f));
        }


        yield return new WaitForSeconds(4);

        float LENGTH = 4;

        lightActor.transform.DOMove(_lightDestination1.position, LENGTH).SetEase(Ease.Linear);
        lightActor.transform.DORotate(_lightDestination1.eulerAngles, 0.6f);
        lightActor.GetActorComponent<IAnimator>().Play(0, "Walk", 0.45f, false);

        darkActor.transform.DOMove(_darkDestination1.position, LENGTH).SetEase(Ease.Linear);
        darkActor.transform.DORotate(_darkDestination1.eulerAngles, 0.6f);
        darkActor.GetActorComponent<IAnimator>().Play(0, "Walk", 0.45f, false);

        float zoomValue = 1.25f;
        DOTween.To(() => zoomValue, x => camera.Zoom(zoomValue = x), 1.75f, LENGTH);


        yield return new WaitForSeconds(LENGTH - 0.2f);

        lightActor.GetActorComponent<IAnimator>().Play(0, "Handshake", 1, false, 0.5f);

        darkActor.GetActorComponent<IAnimator>().Play(0, "Handshake", 1, false, 0.5f);

        yield return new WaitForSeconds(4f / 0.25f);

        darkActor.GetActorComponent<IAnimator>().Play(0, "Left Turn");
        lightActor.GetActorComponent<IAnimator>().Play(0, "Right Turn");

        yield return new WaitForSeconds(2);

        lightActor.GetActorComponent<IAnimator>().SetRootMotion(false);
        darkActor.GetActorComponent<IAnimator>().SetRootMotion(false);

        lightActor.transform.GetComponentInChildren<Rigidbody>().isKinematic = false;
        darkActor.transform.GetComponentInChildren<Rigidbody>().isKinematic = false;


        //lightActor.GetActorComponent<ILightDetector>().isActive = true;
        //darkActor.GetActorComponent<ILightDetector>().isActive = true;

        camera.Zoom(1);

        _moreFloors.gameObject.SetActive(true);

        for (int i = 0; i < _moreFloors.childCount; i++)
        {
            _moreFloors.GetChild(i).transform.position += Vector3.down * 10;
            _moreFloors.GetChild(i).DOMove(_moreFloors.GetChild(i).transform.position + Vector3.up * 10, 4 * UnityEngine.Random.Range(0.5f, 1.5f));
        }

        HomeLevel.GetInstance().SetUniteCutsceneComplete();

    }
}
