using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveablePlatform : MonoBehaviour
{
    public float speed;
    
    private Rigidbody pRigid;
    private bool isMoving = false;
    private Vector3 movingDirection;




    public void Start()
    {
        pRigid = GetComponent<Rigidbody>();
    }

    public void StartMoving(Vector3 direction)
    {
        isMoving = true;
        movingDirection = direction;
    }

    public void MoveLeft()
    {
        StartMoving(new Vector3(-1, 0, 0));

    }
    public void MoveRight()
    {
        StartMoving(new Vector3(1, 0, 0));
    }
    public void MoveForward()
    {
        StartMoving(new Vector3(0, 0, 1));
    }
    public void MoveBackward()
    {
        StartMoving(new Vector3(0, 0, -1));
    }
    public void StopMoving()
    {
        isMoving = false;
        if(pRigid)
        {
            pRigid.velocity = Vector3.zero;
        }
    }
    

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.J))
        {
           StartMoving(new Vector3(-1,0,0));
        }
        else if (Input.GetKeyUp(KeyCode.J))
        {
            StopMoving();
        }


        if (Input.GetKeyDown(KeyCode.L))
        {
            StartMoving(new Vector3(1, 0, 0));
        }
        else if (Input.GetKeyUp(KeyCode.L))
        {
            StopMoving();
        }


        if (Input.GetKeyDown(KeyCode.I))
        {
            StartMoving(new Vector3(0, 0, 1));
        }
        else if (Input.GetKeyUp(KeyCode.I))
        {
            StopMoving();
        }



        if (Input.GetKeyDown(KeyCode.K))
        {
            StartMoving(new Vector3(0, 0, -1));
        }
        else if (Input.GetKeyUp(KeyCode.K))
        {
            StopMoving();
        }

    }


    private void FixedUpdate()
    {
        if (isMoving)
        {
            pRigid.velocity = movingDirection * speed;
        }
        else
        {
            pRigid.velocity = Vector3.zero;
        }
    }
}
