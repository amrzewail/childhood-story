//using Scripts.General;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

namespace Scripts.Areas
{
    public class AreaController : MonoBehaviour, IArea, IRespawner
    {
        public static UnityEvent OnReset = new UnityEvent();

        public string sceneName => this.gameObject.scene.name;

        IRespawnable[] _respawns;
        ISaveable[] _saveables;

        private static List<IArea> _areas;

        [SerializeField] bool setActiveScene = true;
        [SerializeField] List<Object> transitionScenes;

        private IEnumerator Start()
        {
            if (_areas == null) _areas = new List<IArea>();

            if (!_areas.Contains(this)) _areas.Add(this);


            _respawns = transform.GetComponentsInChildren<IRespawnable>();
            _saveables = transform.GetComponentsInChildren<ISaveable>();

            if(transitionScenes != null)
            {
                for (int i = 0; i < transitionScenes.Count; i++)
                {
                    if (!SceneManager.GetSceneByName(transitionScenes[i].name).IsValid())
                    {
                        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(transitionScenes[i].name, LoadSceneMode.Additive);

                        while (!asyncLoad.isDone)
                        {
                            yield return null;
                        }
                    }
                }
            }
            //SaveManager.Load();
            Reload();
        }

        private void OnDestroy()
        {
            if (_areas.Contains(this)) _areas.Remove(this);
        }

        public void Respawn()
        {
            for (int i = 0; i < _respawns.Length; i++)
            {
                _respawns[i].Respawn();
            }
        }

        public void RemoveSaveKeys()
        {
            for (int i = 0; i < _saveables.Length; i++)
            {
                _saveables[i].Remove();
            }
        }

        public void ApplySaveKeys()
        {
            for (int i = 0; i < _saveables.Length; i++)
            {
                _saveables[i].Apply();
            }
        }

        public void ReloadDefault()
        {
            Respawn();
            RemoveSaveKeys();
            ApplySaveKeys();
        }

        public void Reload()
        {
            ApplySaveKeys();
        }

        public static void ResetAll()
        {
            foreach (var area in _areas)
            {
                area.ReloadDefault();
            }
            OnReset?.Invoke();
        }

        public static List<IArea> GetLoadedAreas()
        {
            return _areas;
        }

    }
}