using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingFloor : MonoBehaviour
{
    private Vector3 _startPosition;

    private int _fallenByPlayer = -1;

    private void Start()
    {
        _startPosition = transform.localPosition;

        RespawningSystem.GetInstance().OnPlayerDead.AddListener(PlayerRespawnCallback);
    }

    private void PlayerRespawnCallback(int player)
    {
        if(player == _fallenByPlayer)
        {
            Reposition();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {

        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            Fall();
            _fallenByPlayer = collision.gameObject.GetComponentInChildren<IActorIdentity>().characterIdentifier;
        }
    }

    private void Fall()
    {
        transform.DOLocalMove(_startPosition + Vector3.down * 10, 4);
    }

    public void Reposition()
    {
        transform.DOLocalMove(_startPosition, UnityEngine.Random.Range(0.75f, 1f));
        _fallenByPlayer = -1;
    }
}
