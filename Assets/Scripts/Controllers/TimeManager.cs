using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeManager : MonoBehaviour
{
    private static TimeManager _instance;

    private static float _gameTimeScale = 1;

    public static float gameSpeed { get; set; }

    public static float gameDeltaTime => Time.deltaTime * gameSpeed;

    public static float gameTime { get; private set; }

    public static float gameTimeScale { get => _gameTimeScale; 
        set 
        {
            _gameTimeScale = value;
            Time.timeScale = _gameTimeScale;
        } 
    }

    static TimeManager()
    {
        gameSpeed = 1;
        gameTime = 0;
        _gameTimeScale = 1;

        _instance = new GameObject("Time Manager").AddComponent<TimeManager>();
    }

    private void Awake()
    {
        if (_instance)
        {
            Destroy(this.gameObject);
            return;
        }
        DontDestroyOnLoad(this);
        _instance = this;
    }

    private void Update()
    {
        gameTime += gameDeltaTime;
    }

    public static IEnumerator WaitForGameSeconds(float seconds)
    {
        float time = 0;
        while(time < seconds)
        {
            time += gameDeltaTime;
            yield return null;
        }
    }
}