using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class SwitchPlayerInput : MonoBehaviour
{
    List<PlayerSystemInput> inputs;

    void Start()
    {
        inputs = gameObject.GetComponentsInChildren<PlayerSystemInput>().ToList();    
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F2))
        {
            foreach(var i in inputs)
            {
                i.playerInputIndex = (i.playerInputIndex == 0) ? 1 : 0;
            }
        }
    }
}
