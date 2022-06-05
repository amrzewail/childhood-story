using Scripts.Areas;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Scripts.Areas
{
    public abstract class AreaLoaderBase : MonoBehaviour
    {

        [SerializeField] Object scene;

        protected virtual void Load()
        {
            StartCoroutine(LoadScene(scene.name));
        }

        protected virtual void Unload()
        {
            StartCoroutine(UnloadScene(scene.name));
        }

        private IEnumerator LoadScene(string sceneName)
        {
            if (!SceneManager.GetSceneByName(sceneName).IsValid())
            {
                float ambient = RenderSettings.ambientIntensity;
                AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);

                while (!asyncLoad.isDone)
                {
                    yield return null;
                }
            }
        }

        private IEnumerator UnloadScene(string sceneName)
        {
            if (SceneManager.GetSceneByName(sceneName).IsValid())
            {
                AsyncOperation asyncLoad = SceneManager.UnloadSceneAsync(sceneName);

                while (!asyncLoad.isDone)
                {
                    yield return null;
                }

            }
        }
    }
}