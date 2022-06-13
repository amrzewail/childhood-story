using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainMenuUI : MonoBehaviour
{
    public TextMeshProUGUI changingText;
    public void changeHintText(string hint)
    {
        changingText.text = hint;
    }

    public void onClickNewGame()
    {
        //Debug.Log("You Entered New Game");
        StartCoroutine(LoadNewGame());

        

    }

    private IEnumerator LoadScene(string name, LoadSceneMode mode = LoadSceneMode.Single)
    {
        AsyncOperation load = SceneManager.LoadSceneAsync(name, LoadSceneMode.Additive);
        while (load.isDone == false)
        {
            yield return null;
            Debug.Log($"{name} Loaded");
        }
    }

    private IEnumerator LoadNewGame()
    {

        yield return StartCoroutine(LoadScene("Loading", LoadSceneMode.Additive));
        yield return StartCoroutine(LoadScene("01 - School", LoadSceneMode.Additive));
        yield return StartCoroutine(LoadScene("Players", LoadSceneMode.Additive));

        SceneManager.UnloadSceneAsync("Loading");
        SceneManager.UnloadSceneAsync("Main Menu UI");
    }




    public void onClickExit()
    {
        Application.Quit();

    }
}
