using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class SplitKeyboard : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        PlayerInput.Instantiate(GetComponent<PlayerInputManager>().playerPrefab, controlScheme: "Keyboard", pairWithDevice: Keyboard.current);
        PlayerInput.Instantiate(GetComponent<PlayerInputManager>().playerPrefab, controlScheme: "RKeyboard", pairWithDevice: Keyboard.current);
    }
}
