using Characters;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Pushable : MonoBehaviour, IPushable
{
    [SerializeField] UnityEvent OnStartPush;
    [SerializeField] UnityEvent OnEndPush;

    [SerializeField] private Transform sidescontroller;
    private Transform holdingPoint;
    IActor actor;

    private List<Transform> transform_sides;
    private float minDistance;
    private int minDistanceIndex;
    private IDictionary<string, object> data;
    private Vector3 differenceOffset;

    private bool isPushing = false;
    private bool canMove = false;

    private Collider _myCollider;
    private BoxCollider _playerExtraCollider;


    void Start()
    {
        _myCollider = GetComponent<Collider>();

        transform_sides = new List<Transform>();
        for (int i = 0; i < sidescontroller.childCount; i++)
        {
            var child = sidescontroller.GetChild(i);
            if (child.gameObject.activeSelf)
            {
                transform_sides.Add(child);
            }
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

                this.gameObject.transform.position += differenceOffset;

                actor.transform.eulerAngles = transform_sides[minDistanceIndex].eulerAngles;

            }
            else
            {
                actor.transform.eulerAngles = transform_sides[minDistanceIndex].eulerAngles;

                differenceOffset = transform_sides[minDistanceIndex].position - holdingPoint.transform.position;
                differenceOffset.y = 0;
                actor.transform.position += differenceOffset * Time.deltaTime * 5;

                //Debug.Log(differenceOffset.magnitude);

                if(differenceOffset.magnitude < 0.05f)
                {
                    canMove = true;

                    if (!_playerExtraCollider)
                    {
                        if(_myCollider is BoxCollider)
                        {
                            _playerExtraCollider = actor.transform.gameObject.AddComponent<BoxCollider>();
                            Vector3 size = Vector3.Scale(((BoxCollider)_myCollider).size, transform.localScale);
                            size.y = 0.01f;
                            _playerExtraCollider.size = size;
                            _playerExtraCollider.center = transform.position + ((BoxCollider)_myCollider).center;
                            _playerExtraCollider.center = actor.transform.InverseTransformPoint(_playerExtraCollider.center);
                        }else if (_myCollider is SphereCollider)
                        {
                            _playerExtraCollider = actor.transform.gameObject.AddComponent<BoxCollider>();
                            Vector3 size = Vector3.Scale(Vector3.one * ((SphereCollider)_myCollider).radius, transform.localScale);
                            size.y = 0.01f;
                            _playerExtraCollider.size = size;
                            _playerExtraCollider.center = (transform.position - actor.transform.position) + ((SphereCollider)_myCollider).center;
                        }



                        _myCollider.enabled = false;
                        GetComponent<Rigidbody>().useGravity = false;
                    }
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
        for (int i = 0; i < transform_sides.Count; i++)
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

        OnStartPush?.Invoke();
    }


    public void StopPush(IDictionary<string, object> data)
    {
        isPushing = false;
        canMove = false;

        if (_playerExtraCollider)
        {
            Destroy(_playerExtraCollider);
            GetComponent<Collider>().enabled = true;
            GetComponent<Rigidbody>().useGravity = true;
        }

        OnEndPush?.Invoke();
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
