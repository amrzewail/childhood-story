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
    private float minDistance;
    private int minDistanceIndex;
    private IDictionary<string, object> data;
    private Vector3 differenceOffeset;
    private bool isPushing=false;
    void Start()
    {
        
        transform_sides = new Transform[4];
        for (int i = 0; i < sidescontroller.childCount; i++)
        {
            transform_sides[i] = sidescontroller.GetChild(i);
        }
    }

    void LateUpdate()
    {
        //transform_sides[0].position = holdingpoint.transform.position;
        if(isPushing)
        {
            differenceOffeset = holdingPoint.transform.position-transform_sides[minDistanceIndex].position;
            this.gameObject.transform.position += differenceOffeset;
            actor.transform.eulerAngles = transform_sides[minDistanceIndex].eulerAngles;

        }
        //transform_sides[0].localPosition = transformside1;
    }

    public void StartPush(IDictionary<string, object> data)
    {
        actor = (IActor)data["actor"];
        IPusher pusher = actor.GetActorComponent<IPusher>(0);
        holdingPoint = pusher.holdingPoint;

        minDistance = float.MaxValue;
        for (int i = 0; i < transform_sides.Length; i++)
        {
            float distance = Vector3.Distance(transform_sides[i].position, actor.transform.position);
            if(distance < minDistance)
            {
                minDistance = distance;
                minDistanceIndex = i;
            }
        }

        actor.transform.eulerAngles = transform_sides[minDistanceIndex].eulerAngles; 
        differenceOffeset = transform_sides[minDistanceIndex].position - holdingPoint.transform.position;
        actor.transform.position += differenceOffeset;

        isPushing = true;
    }


    public void StopPush(IDictionary<string, object> data)
    {
        isPushing = false;

    }

    public bool CanPush()
    {
        return !isPushing;
    }
}
