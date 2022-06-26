using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Bossfight : MonoBehaviour
{
    public static Bossfight Instance { get; private set; }

    private int _explosionCount = 0;

    [SerializeField] Parent _mother;
    [SerializeField] Parent _father;

    [Space]

    [SerializeField] MultiButtonTrigger _firstButtons;
    [SerializeField] List<ExplosiveBrick> _firstExplosives;
    [SerializeField] List<Transform> _firstBrokenFloors;

    [Space]

    [SerializeField] MultiButtonTrigger _secondButtons;
    [SerializeField] List<ExplosiveBrick> _secondExplosives;
    [SerializeField] List<Transform> _secondBrokenFloors;

    public Parent mother => _mother;
    public Parent father => _father;
    

    private void Awake()
    {
        Instance = this;

        _secondButtons.gameObject.SetActive(false);

        _firstButtons.OnButtonsDown.AddListener(() => Explode());
        _secondButtons.OnButtonsDown.AddListener(() => Explode());

    }


    public void Explode()
    {
        switch (_explosionCount)
        {
            case 0:
                _firstExplosives.ForEach(x => x.Explode());
                _firstBrokenFloors.ForEach(x => x.gameObject.SetActive(false));


                mother.ShootBullet();
                father.ShootBullet();

                _firstButtons.gameObject.SetActive(false);

                _secondButtons.gameObject.SetActive(true);

                break;

            case 1:
                _secondExplosives.ForEach(x => x.Explode());
                _secondBrokenFloors.ForEach(x => x.gameObject.SetActive(false));


                mother.StopShootBullet();
                father.StopShootBullet();

                mother.ShootGhost();
                father.ShootGhost();

                _secondButtons.gameObject.SetActive(false);

                break;
        }

        _explosionCount++;
    }

}
