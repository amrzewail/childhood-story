using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;


public class AnimatedFloors : MonoBehaviour
{
    private void Awake()
    {
        gameObject.SetActive(false);
    }

    public void Show()
    {
        if (gameObject.activeSelf) return;

        gameObject.SetActive(true);

        Vector3 offset = new Vector3(0, -30, 0);

        int childCount = transform.childCount;

        for(int i= 0; i < childCount; i++)
        {
            Transform child = transform.GetChild(i);

            Vector3 startPosition = child.position;

            child.position += offset;

            child.DOMove(startPosition, UnityEngine.Random.Range(1f, 3f), false);
        }

    }
}
