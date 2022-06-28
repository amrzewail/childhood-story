using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntervalShooter : MonoBehaviour
{
    private Vector3 startPosition;

    enum Type
    {
        Sine,
        Random
    }

    [SerializeField] Type type = Type.Sine;
    [SerializeField] CharacterShooter shooter;
    [SerializeField] float delay = 0;
    [SerializeField] float interval = 1;
    [SerializeField] Vector3 positionOffset;
    [SerializeField] float speed = 0;


    void Start()
    {
        startPosition = transform.position;

        StartCoroutine(Do());
    }

    private IEnumerator Do()
    {
        yield return new WaitForSeconds(delay);
        while (true)
        {
            if (shooter != null)
            {
                shooter.Shoot(transform.position + transform.forward);
            }
            yield return new WaitForGameSeconds(interval);

        }
    }

    private void OnEnable()
    {
        StartCoroutine(Do());
    }

    private void Update()
    {
        switch (type)
        {
            case Type.Sine:
                transform.position = Vector3.Lerp(startPosition, startPosition + positionOffset, 0.5f * (Mathf.Sin(TimeManager.gameTime * speed) + 1));

                break;

            case Type.Random:
                transform.position = Vector3.Lerp(startPosition, startPosition + positionOffset, UnityEngine.Random.Range(0f, 1f));

                break;
        }

    }
}
