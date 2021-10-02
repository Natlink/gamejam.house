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

    void FixedUpdate()
    {

        float xDirection = Input.GetAxisRaw("Horizontal") * Speed;
        float zDirection = Input.GetAxisRaw("Vertical") * Speed;
        if (xDirection != 0 || zDirection != 0)
            Move(xDirection, zDirection);
    }


    void Move(float xDirection, float zDirection)
    {
        Rgbd.AddForce(new Vector3(xDirection, 0, zDirection));
        
        Vector3 velocity = Rgbd.velocity;

        if (velocity.sqrMagnitude > MaxVelocity*MaxVelocity)
        {
            float factor = MaxVelocity / velocity.magnitude;
            velocity.x = velocity.x * factor;
            velocity.z = velocity.z * factor;
        }
        
        Rgbd.velocity = velocity;
    }

}

