using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingEntity : AbstractEntity
{

    public float Speed;
    public float MaxVelocity;
    public Rigidbody Rgbd;

    // Start is called before the first frame update
    void Start()
    {
        Rgbd = this.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {

        float xDirection = Input.GetAxis("Horizontal") * Speed;
        float zDirection = Input.GetAxis("Vertical") * Speed;
        if (xDirection != 0 || zDirection != 0)
            Move(xDirection, zDirection);
    }


    void Move(float xDirection, float zDirection)
    {
        Rgbd.AddForce(new Vector3(xDirection, 0, zDirection));
        
        Vector3 velocity = Rgbd.velocity;

        if (Mathf.Abs(velocity.x) > MaxVelocity)
        {
            if (Mathf.Abs(velocity.z) > MaxVelocity)
            {
                velocity.x = velocity.x > 0 ? MaxVelocity : -MaxVelocity;
                velocity.z = velocity.z > 0 ? MaxVelocity : -MaxVelocity;
                //x y
            }
            else
            {
                velocity.x = velocity.x > 0 ? MaxVelocity : -MaxVelocity;
                // x
            }
        }
        else if (Mathf.Abs(velocity.z) > MaxVelocity)
        {
            velocity.z = velocity.z > 0 ? MaxVelocity : -MaxVelocity;
            // y
        }
        
        Rgbd.velocity = velocity;
    }

}

