using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TutorialTrigger : MonoBehaviour
{
    [SerializeField] int _tutorialIndex;

    private void OnTriggerStay(Collider other)
    {

        if (other.gameObject.CompareTag("Player"))
        {
            TutorialUI.SHOW?.Invoke(_tutorialIndex);
        }

    }
}
