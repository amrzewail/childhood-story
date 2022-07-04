using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerUI : MonoBehaviour
{
    [SerializeField] GameObject health;

    private IEnumerator Start()
    {
        while (true)
        {
            if(Bossfight.Instance && Bossfight.Instance.isBossStarted)
            {
                if(!health.activeSelf) health.SetActive(true);
            }
            else
            {
                if (health.activeSelf) health.SetActive(false);
            }
            yield return new WaitForSeconds(1);
        }
    }
}
