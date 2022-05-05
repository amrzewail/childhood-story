using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntervalShooter : MonoBehaviour
{
    private Vector3 startPosition;

    [SerializeField] CharacterShooter shooter;
    [SerializeField] float delay = 0;
    [SerializeField] float interval = 1;
    [SerializeField] Vector3 positionOffset;
    [SerializeField] float speed = 0;


    IEnumerator Start()
    {
        startPosition = transform.position;

        yield return new WaitForSeconds(delay);
        while (true)
        {
            yield return new WaitForGameSeconds(interval);

            shooter.Shoot(transform.position + transform.forward);
        }
    }

    private void Update()
    {
        transform.position = Vector3.Lerp(startPosition, startPosition + positionOffset, 0.5f * (Mathf.Sin(TimeManager.gameTime * speed) + 1));
    }
}
