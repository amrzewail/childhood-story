using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovePlatform : MonoBehaviour
{
    public float speed;
    Rigidbody pRigid;
    bool isMoving = false;

    public void Start()
    {
        pRigid = GetComponent<Rigidbody>();
    }

    public void StartMoving(Vector3 direction)
    {
        isMoving = true;
        pRigid.velocity = direction * speed;
    }

    /*public void moveLeft()
    {
        isMoving = true;
        pRigid.velocity = new Vector3(-1, 0, 0) * speed;
        
    }
    public void moveRight()
    {
        isMoving = true;
        pRigid.velocity = new Vector3(1, 0, 0) * speed;
    }
    public void moveForward()
    {
        isMoving = true;
        pRigid.velocity = new Vector3(0, 0, 1) * speed;
    }
    public void moveBackward()
    {
        isMoving = true;
        pRigid.velocity = new Vector3(0, 0, -1) * speed;
    }*/
    public void StopMoving()
    {
        isMoving = false;
        pRigid.velocity = Vector3.zero;
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
        if (isMoving == false)
        {
            pRigid.velocity = Vector3.zero;
        }


    }
    private void FixedUpdate()
    {
        
    }
}
