using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class Bossfight : MonoBehaviour
{
    public static Bossfight Instance { get; private set; }

    public UnityEvent OnExplosionComplete;

    public UnityEvent OnBossComplete;

    public bool isFloorFalling = false;


    private int _explosionCount = 0;

    [SerializeField] Parent _mother;
    [SerializeField] Parent _father;

    [Space]

    [SerializeField] int _numbersOfIterations = 6;

    [SerializeField] Transform _temporaryBarrier;
    [SerializeField] Transform _brickStacksParent;
    [SerializeField] List<MultiButtonTrigger> _triggers;
    [SerializeField] List<ExplosiveBrick> _explosives;
    [SerializeField] List<CheckPoint> _checkpoints;

    [Space]
    [SerializeField] AudioClip _clip;

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
        _mother.gameObject.SetActive(false);
        _father.gameObject.SetActive(false);
        _brickStacksParent.gameObject.SetActive(false);
    }

    private void Update()
    {
        if (Input.GetKeyDown("u"))
        {
            Explode();
        }
    }

    public void Begin()
    {

        StartCoroutine(BeginCoroutine());

        BGMPlayer.GetInstance().Play(_clip);

    }

    private IEnumerator BeginCoroutine()
    {
        _temporaryBarrier.gameObject.SetActive(true);

        yield return StartCoroutine(LayoutBricks());

        yield return StartCoroutine(LayoutParents());

        yield return StartCoroutine(LayoutButtons());

        _temporaryBarrier.gameObject.SetActive(false);
    }

    private IEnumerator LayoutBricks()
    {
        float LENGTH = 0.15f;

        _brickStacksParent.gameObject.SetActive(true);

        for (int i = 0; i < _brickStacksParent.childCount; i++)
        {
            Vector3 position = _brickStacksParent.GetChild(i).position;
            _brickStacksParent.GetChild(i).position += Vector3.up * 20;
            _brickStacksParent.GetChild(i).DOMove(position, 0.5f).SetDelay(LENGTH * i).SetEase(Ease.InSine);
        }

        yield return new WaitForSeconds(LENGTH * _brickStacksParent.childCount);
    }

    private IEnumerator LayoutParents()
    {
        float LENGTH = 0.25f;

        _mother.gameObject.SetActive(true);
        _father.gameObject.SetActive(true);

        _mother.transform.localScale = Vector3.one * 0.001f;
        _father.transform.localScale = Vector3.one * 0.001f;

        _mother.transform.DOScale(1, LENGTH);
        _father.transform.DOScale(1, LENGTH);

        yield return new WaitForSeconds(LENGTH);
    }

    private IEnumerator LayoutButtons()
    {
        _triggers[0].gameObject.SetActive(true);

        yield return null;
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


        //_checkpoints[(_explosionCount + 1) % _checkpoints.Count].Activate(0, true);
        //_checkpoints[(_explosionCount + 1) % _checkpoints.Count].Activate(1, true);


        OnExplosionComplete?.Invoke();

        //mother.ShootGhost();
        //father.ShootGhost();


        _explosionCount++;

        if(_explosionCount >= _numbersOfIterations)
        {
            //TimeManager.gameTimeScale = 0.1f;
            OnBossComplete?.Invoke();

            _triggers[currentButtons].gameObject.SetActive(false);

            CameraEffects.FadeInstant(1);

            BGMPlayer.GetInstance().Stop();

            SceneManager.LoadScene("Credits");


        }

        if(_explosionCount >= 2)
        {
            _mother.ShootBullet();
            _father.ShootBullet();
        }

        if(_explosionCount >= 4)
        {
            isFloorFalling = true;
        }
    }

}
