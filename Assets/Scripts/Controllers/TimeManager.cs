using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeManager : MonoBehaviour
{
    private static TimeManager _instance;

    public static float gameSpeed { get; set; }

    public static float gameDeltaTime => Time.deltaTime * gameSpeed;

    public static float gameTime { get; private set; }

    static TimeManager()
    {
        gameSpeed = 1;
        gameTime = 0;

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