using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LegacyInput : MonoBehaviour, IInput
{

    public Vector2 axis { get; private set; }

    public Vector2 absAxis { get; private set; }

    public Vector2 aimAxis => throw new System.NotImplementedException();

    private void Update()
    {
        var a = axis;

        a.x = 0;
        a.y = 0;
        if (Input.GetKey(KeyCode.D))
        {
            a.x += 1;
        }
        if (Input.GetKey(KeyCode.A))
        {
            a.x -= 1;
        }
        if (Input.GetKey(KeyCode.W))
        {
            a.y += 1;
        }
        if (Input.GetKey(KeyCode.S))
        {
            a.y -= 1;
        }

        float radians = -Camera.main.transform.eulerAngles.y * Mathf.PI / 180;
        float cos = Mathf.Cos(radians), sin = Mathf.Sin(radians);
        var ax = a;
        ax.x = cos * a.x - sin * a.y;
        ax.y = cos * a.y + sin * a.x;

        axis = ax;

        if (a.magnitude > 0) absAxis = a;
    }

    public bool IsKeyDown(string key)
    {
        return false;
    }

    public bool IsKeyUp(string key)
    {
        throw new System.NotImplementedException();
    }
}
