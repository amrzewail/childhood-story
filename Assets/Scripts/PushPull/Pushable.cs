using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pushable : MonoBehaviour,IPushable
{
    [SerializeField] private Transform sidescontroller;
    private Transform[] transform_sides;
    private float[] distance;
    [SerializeField]private Transform holdingpoint;
    [SerializeField]private Transform actor;
    private float mindistance;
    private int indexmindistance;
    void Start()
    {
        transform_sides = new Transform[4];
        for (int i = 0; i < sidescontroller.childCount; i++)
        {
            transform_sides[i] = sidescontroller.GetChild(i);
        }
        distance = new float[4];


    }
    void Update()
    {
        for (int i = 0; i < transform_sides.Length; i++)
        {
            distance[i] = Vector3.Distance(transform_sides[i].position, holdingpoint.position);
            Debug.Log("index  " + i + "   " + distance[i]);
        }

        mindistance = Mathf.Min(distance);
        indexmindistance=System.Array.IndexOf(distance, mindistance);

    }

    public void StartPush(IDictionary<string, object> data)
    {
        actor.LookAt(transform_sides[indexmindistance]);
    }

    public void StopPush(IDictionary<string, object> data)
    {
        throw new System.NotImplementedException();
    }

    // Start is called before the first frame update


    // Update is called once per frame

}
