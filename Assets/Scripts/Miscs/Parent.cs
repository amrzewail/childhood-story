using Characters;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Parent : MonoBehaviour
{
    private Coroutine _bulletShootingCoroutine;
    private Coroutine _ghostShootingCoroutine;

    [SerializeField] CharacterShooter _shooter;
    [SerializeField] CharacterShooter _ghostShooter;
    [SerializeField] int _targetPlayer = 0;

    [SerializeField] float _bulletInterval;
    [SerializeField] float _ghostInterval;
    [SerializeField] int _maxGhostCount = 10;

    private int _ghostCount = 0;


    private IActor _targetActor = null;

    private void Start()
    {
        _targetActor = this.FindInterfacesOfType<IActor>().SingleOrDefault(x => x.GetActorComponent<IActorIdentity>().characterIdentifier == _targetPlayer);
    }

    public void ShootBullet()
    {
        _bulletShootingCoroutine = StartCoroutine(StartShootingBullets());
    }

    public void ShootGhost()
    {
        if (_ghostCount < _maxGhostCount)
        {
            _ghostShootingCoroutine = StartCoroutine(StartShootingGhosts());
        }
    }

    public void StopShootBullet()
    {
        StopCoroutine(_bulletShootingCoroutine);
    }

    public void StopShootGhost()
    {
        StopCoroutine(_ghostShootingCoroutine);
    }

    private IEnumerator StartShootingBullets()
    {
        while (true)
        {
            _shooter.Shoot(_targetActor.transform);
            yield return new WaitForGameSeconds(_bulletInterval);
        }
    }
    private IEnumerator StartShootingGhosts()
    {
        while (true)
        {
            if (_ghostCount < _maxGhostCount)
            {
                _ghostShooter.Shoot(_targetActor.transform);
                _ghostCount++;
            }
            yield return new WaitForGameSeconds(_ghostInterval);
        }
    }
}
