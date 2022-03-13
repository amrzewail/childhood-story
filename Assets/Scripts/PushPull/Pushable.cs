using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pushable : MonoBehaviour,IPushable
{
    [SerializeField]private Transform sidescontroller;
    [SerializeField]private GameObject holdingpoint;
    [SerializeField]private GameObject actor;

    private Transform[] transform_sides;
    private float[] distance;
    private float mindistance;
    private int indexmindistance;
    private IDictionary<string, object> data;
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
            distance[i] = Vector3.Distance(transform_sides[i].position, holdingpoint.transform.position);
            Debug.Log("index  " + i + "   " + distance[i]);
        }

        mindistance = Mathf.Min(distance);
        indexmindistance=System.Array.IndexOf(distance, mindistance);
    }

    public void StartPush(IDictionary<string, object> data)
    {
        actor.transform.LookAt(transform_sides[indexmindistance]);
        gameObject.GetComponent<FixedJoint>().connectedBody = actor.GetComponent<Rigidbody>();
        
    }

    public void StopPush(IDictionary<string, object> data)
    {
        actor.transform.LookAt(null);
        this.GetComponent<FixedJoint>().connectedBody = null;
    }
    

}
