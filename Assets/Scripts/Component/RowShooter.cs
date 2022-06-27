using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RowShooter : MonoBehaviour
{
    public CharacterShooter shooter;
    public int count = 5;
    public float spacing = 1;
    public float interval = 0;
    public float delay = 0;

    private Vector3 _startPosition;

    private void Start()
    {

        _startPosition = transform.position;
        StartCoroutine(Do());
    }
    private void OnEnable()
    {
        StopAllCoroutines();
        StartCoroutine(Do());
    }

    private IEnumerator Do()
    {
        yield return new WaitForSeconds(delay);
        while (true)
        {
            transform.position = _startPosition;

            for (int i = 0; i < count; i++)
            {
                shooter.Shoot(transform.position + transform.forward);
                transform.position += transform.right * spacing;
            }

            transform.position = _startPosition;

            yield return new WaitForGameSeconds(interval);

        }
    }

}
