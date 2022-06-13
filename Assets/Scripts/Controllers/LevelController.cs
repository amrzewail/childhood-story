using Characters;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class LevelController : MonoBehaviour
{


    internal void Start()
    {
        SceneManager.SetActiveScene(gameObject.scene);

        RespawningSystem.GetInstance().RespawnPlayers();

        RespawningSystem.GetInstance().OnGameOver.AddListener(GameOverCallback);
    }

    private void GameOverCallback()
    {
        string sceneName = SceneManager.GetActiveScene().name;
        SceneManager.UnloadSceneAsync(sceneName);

        RespawningSystem.GetInstance().ResetCheckpoints();



        UnityAction<Scene, LoadSceneMode> sceneLoadedCallback = null;
        sceneLoadedCallback = (Scene scene, LoadSceneMode mode) =>
        {
            SceneManager.SetActiveScene(SceneManager.GetSceneByName(sceneName));

            RespawningSystem.GetInstance().RespawnPlayers();

            SceneManager.sceneLoaded -= sceneLoadedCallback;
        };
        SceneManager.sceneLoaded += sceneLoadedCallback;


        SceneManager.LoadScene(sceneName, LoadSceneMode.Additive);

    }


}

