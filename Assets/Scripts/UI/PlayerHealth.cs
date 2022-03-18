using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace UI
{
    using Object = UnityEngine.Object;

    public class PlayerHealth : MonoBehaviour
    {
        [SerializeField] [RequireInterface(typeof(IHealth))] Object _health;
        [SerializeField] Transform heartsContainer;
        public IHealth health => (IHealth)_health;

        internal IEnumerator Start()
        {
            while (true)
            {
                UpdateUI();

                yield return new WaitForSeconds(0.2f);
            }
        }

        internal void OnEnable()
        {
            StopAllCoroutines();
            StartCoroutine(Start());
        }

        private void UpdateUI()
        {
            int healthValue = health.GetValue();
            Func<int> currentPoints = () =>
            {
                var childCount = heartsContainer.childCount;
                if (childCount == 1)
                {
                    if (heartsContainer.GetChild(0).gameObject.activeSelf == false) return 0;
                }
                return childCount;
            };

            if (healthValue > currentPoints())
            {
                if (currentPoints() == 0)
                {
                    heartsContainer.GetChild(0).gameObject.SetActive(true);
                }
                else
                {
                    Instantiate(heartsContainer.GetChild(0), heartsContainer);
                }
            }

            if (healthValue < currentPoints())
            {
                if(currentPoints() > 1)
                {
                    Destroy(heartsContainer.GetChild(0).gameObject);
                }
                else
                {
                    heartsContainer.GetChild(0).gameObject.SetActive(false);
                }
            }
        }
    }
}