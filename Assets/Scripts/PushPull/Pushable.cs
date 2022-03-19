using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pushable : MonoBehaviour, IPushable
{
    [SerializeField]private Transform sidescontroller;
    private Transform holdingPoint;
    IActor actor;

    private Transform[] transform_sides;
    private float minDistance;
    private int minDistanceIndex;
    private IDictionary<string, object> data;
    private Vector3 differenceOffset;

    private bool isPushing = false;
    private bool canMove = false;


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
            if(canMove)
            {

                differenceOffset = holdingPoint.transform.position - transform_sides[minDistanceIndex].position;
                differenceOffset.y = 0;
                if (differenceOffset.magnitude > 0.05f)
                {
                    this.gameObject.transform.position += differenceOffset;
                }
                actor.transform.eulerAngles = transform_sides[minDistanceIndex].eulerAngles;
            }
            else
            {
                actor.transform.eulerAngles = transform_sides[minDistanceIndex].eulerAngles;

                differenceOffset = transform_sides[minDistanceIndex].position - holdingPoint.transform.position;
                differenceOffset.y = 0;
                actor.transform.position += differenceOffset * Time.deltaTime * 5;

                if(differenceOffset.magnitude < 0.05f)
                {
                    canMove = true;
                }
            }

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

        isPushing = true;
        canMove = false;
    }


    public void StopPush(IDictionary<string, object> data)
    {
        isPushing = false;
        canMove = false;
    }

    public bool CanPush()
    {
        return !isPushing;
    }

    public bool CanMove()
    {
        return canMove;
    }
}
