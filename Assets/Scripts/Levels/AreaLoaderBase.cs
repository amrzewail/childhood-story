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

        [ReadOnly, SerializeField] private string _sceneName;

#if UNITY_EDITOR

        private void OnValidate()
        {
            if (scene)
            {
                _sceneName = scene.name;
            }    
        }

#endif

        protected virtual void Load()
        {
            StartCoroutine(LoadScene(_sceneName));
        }

        protected virtual void Unload()
        {
            StartCoroutine(UnloadScene(_sceneName));
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

                if (!SaveManager.GetInstance().Current.scenes.Contains(sceneName))
                {
                    SaveManager.GetInstance().Current.scenes.Add(sceneName);
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

                if (SaveManager.GetInstance().Current.scenes.Contains(sceneName))
                {
                    SaveManager.GetInstance().Current.scenes.Remove(sceneName);
                }
            }
        }
    }
}