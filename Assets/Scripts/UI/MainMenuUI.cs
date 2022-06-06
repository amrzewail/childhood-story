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

    private IEnumerator LoadNewGame()
    {
        SceneManager.LoadScene("Loading",LoadSceneMode.Additive);
        AsyncOperation load = SceneManager.LoadSceneAsync("School whitebox", LoadSceneMode.Additive);
        while(load.isDone == false)
        {
            yield return null;
            Debug.Log("Players Loaded");
        }

        AsyncOperation load2 = SceneManager.LoadSceneAsync("Players", LoadSceneMode.Additive);
        while (load2.isDone == false)
        {
            yield return null;
            Debug.Log("Players Loaded");
        }
        SceneManager.UnloadSceneAsync("Loading");
        SceneManager.UnloadSceneAsync("Main Menu UI");
    }




    public void onClickExit()
    {
        Application.Quit();

    }
}
