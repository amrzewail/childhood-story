using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pushable : MonoBehaviour,IPushable
{
    [SerializeField]private Transform sidescontroller;
    private Transform holdingPoint;
    IActor actor;

    private Transform[] transform_sides;
    private float[] distance;
    private float mindistance;
    private int indexmindistance;
    private IDictionary<string, object> data;
    private Vector3 differenceOffeset;
    private bool ispush=false;
    void Start()
    {
        
        transform_sides = new Transform[4];
        for (int i = 0; i < sidescontroller.childCount; i++)
        {
            transform_sides[i] = sidescontroller.GetChild(i);
        }
        distance = new float[4];

    }

    void LateUpdate()
    {
        //transform_sides[0].position = holdingpoint.transform.position;
        if(ispush)
        {
            differenceOffeset = holdingPoint.transform.position-transform_sides[indexmindistance].position;
            this.gameObject.transform.position += differenceOffeset;
        }
        //transform_sides[0].localPosition = transformside1;
    }

    public void StartPush(IDictionary<string, object> data)
    {
        IActor actor = (IActor)data["actor"];
        IPusher pusher = actor.GetActorComponent<IPusher>(0);
        holdingPoint = pusher.holdingPoint;
        ispush = true;
        for (int i = 0; i < transform_sides.Length; i++)
        {
            distance[i] = Vector3.Distance(transform_sides[i].position, holdingPoint.transform.position);
            //Debug.Log("index  " + i + "   " + distance[i]);
        }

        mindistance = Mathf.Min(distance);
        indexmindistance = System.Array.IndexOf(distance, mindistance);
        actor.transform.eulerAngles = transform_sides[indexmindistance].eulerAngles; 
        differenceOffeset = transform_sides[indexmindistance].position - holdingPoint.transform.position;
        actor.transform.position += differenceOffeset;
        //var actorEuler = actor.transform.eulerAngles;
        //actor.transform.LookAt(transform_sides[indexmindistance]);
        //actor.transform.eulerAngles = new Vector3(actorEuler.x, actor.transform.eulerAngles.y,actorEuler.z);

        //actorEuler.y = actor.transform.eulerAngles.y;
        //actor.transform.eulerAngles = actorEuler;


    }
    public void StopPush(IDictionary<string, object> data)
    {
        ispush = false;
        //actor.transform.LookAt(null);
        //this.GetComponent<FixedJoint>().connectedBody = null;
    }

    public bool CanPush()
    {
        return !ispush;
    }
}
