using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Bossfight : MonoBehaviour
{
    public UnityEvent OnExplosionComplete;

    public UnityEvent OnBossComplete;

    public static Bossfight Instance { get; private set; }

    private int _explosionCount = 0;

    [SerializeField] Parent _mother;
    [SerializeField] Parent _father;

    [Space]

    [SerializeField] int _numbersOfIterations = 6;

    [SerializeField] List<MultiButtonTrigger> _triggers;
    [SerializeField] List<ExplosiveBrick> _explosives;
    [SerializeField] List<CheckPoint> _checkpoints;

    public Parent mother => _mother;
    public Parent father => _father;
    

    private void Awake()
    {
        Instance = this;

        _triggers.ForEach(x => x.OnButtonsDown.AddListener(Explode));
        _triggers.ForEach(x => x.gameObject.SetActive(false));

    }

    private void Start()
    {
        Begin();
    }

    private void Begin()
    {
        _triggers[0].gameObject.SetActive(true);
    }


    public void Explode()
    {
        int currentButtons = (_explosionCount + 1) % _triggers.Count;

        _triggers.ForEach(x => x.OnButtonsDown.RemoveAllListeners());

        _triggers[_explosionCount % _triggers.Count].gameObject.SetActive(false);

        _triggers[currentButtons].gameObject.SetActive(true);

        _triggers[currentButtons].OnButtonsDown.AddListener(Explode);


        _explosives[_explosionCount].Explode();
        _explosives[_explosives.Count - _explosionCount - 1].Explode();


        _checkpoints[(_explosionCount + 1) % _checkpoints.Count].Activate(0, true);
        _checkpoints[(_explosionCount + 1) % _checkpoints.Count].Activate(1, true);


        OnExplosionComplete?.Invoke();

        //mother.ShootGhost();
        //father.ShootGhost();


        _explosionCount++;

        if(_explosionCount >= _numbersOfIterations)
        {
            TimeManager.gameSpeed = 0;
            OnBossComplete?.Invoke();
        }
    }

}
