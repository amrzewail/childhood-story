using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

using Newtonsoft.Json;
using UnityEngine.SceneManagement;

public class SaveManager : Singleton<SaveManager>
{
    public static string PATH => Application.persistentDataPath + "/save.g";

    public Save Current { get; private set; } = null;

    public bool isNewGame = false;

    public override void Awake()
    {
        base.Awake();

        if (File.Exists(PATH))
        {
            Current = JsonConvert.DeserializeObject<Save>(File.ReadAllText(PATH));
        }
    }

    public void Save()
    {
        if (Current == null) return;

        string text = JsonConvert.SerializeObject(Current);

        File.WriteAllText(PATH, text);
    }

    public void New()
    {
        Current = new Save();

        Current.checkpoint = "School 1";
        Current.scenes.Add("01 - School");

        Save();
    }

}

public class Save
{
    public string checkpoint;
    public List<string> scenes = new List<string>();
}
