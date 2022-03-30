
using UnityEngine;

public class MoveCube : MonoBehaviour
{
    public float speed = 5f;
    void Update()
    {
        Vector3 pos = transform.position;
        pos.x = Mathf.Sin(TimeManager.gameTime * speed);

        transform.position = pos;
    }   
}
