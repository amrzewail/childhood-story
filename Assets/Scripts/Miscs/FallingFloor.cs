using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingFloor : MonoBehaviour
{
    private Vector3 _startPosition;
    private float _repositionDelay = 0;

    private int _fallenByPlayer = -1;

    [SerializeField] bool _isPermanent=false;
    private void Start()
    {
        _startPosition = transform.localPosition;

        //RespawningSystem.GetInstance().OnPlayerRespawn.AddListener(PlayerRespawnCallback);

        //Bossfight.Instance.OnExplosionComplete.AddListener(ExplosionCompleteCallback);
    }

    private void PlayerRespawnCallback(int player)
    {
        if(player == _fallenByPlayer)
        {
            Reposition();
            _fallenByPlayer = -1;
        }
    }

    private void ExplosionCompleteCallback()
    {
        Reposition();
        _fallenByPlayer = -1;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {

        }
    }

    private void OnTriggerExit(Collider collision)
    {
        if (Bossfight.Instance.isFloorFalling == false) return;

        if (collision.gameObject.CompareTag("Player"))
        {
            if (_fallenByPlayer == -1)
            {
                Fall();
                _fallenByPlayer = collision.gameObject.GetComponentInChildren<IActorIdentity>().characterIdentifier;
            }
        }
    }

    private void Fall()
    {
        transform.DOLocalMove(_startPosition + Vector3.down * 10, 4);

        if (_isPermanent) return;

        StartCoroutine(RepositionDelayed());
    }

    private IEnumerator RepositionDelayed()
    {
        yield return new WaitForGameSeconds(UnityEngine.Random.Range(5f, 10f) + _repositionDelay++);

        Reposition();
        _fallenByPlayer = -1;

        _repositionDelay = Mathf.Clamp(_repositionDelay, 0, 10);
    }

    public void Reposition()
    {
        StopAllCoroutines();
        transform.DOKill(false);
        transform.DOLocalMove(_startPosition, UnityEngine.Random.Range(0.75f, 1f));
    }
}
