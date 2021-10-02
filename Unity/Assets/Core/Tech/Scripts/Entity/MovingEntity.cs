 using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingEntity : AbstractEntity
{

    public float Acceleration =10;
    public float MaxSpeed=5;
    public Rigidbody Rgbd;

    // Start is called before the first frame update
    void Start()
    {
        Rgbd = this.GetComponent<Rigidbody>();
    }

    void FixedUpdate()
    {

        float xDirection = Input.GetAxisRaw("Horizontal") * Acceleration * 10;
        float zDirection = Input.GetAxisRaw("Vertical") * Acceleration * 10;
        if (xDirection != 0 || zDirection != 0)
            Move(xDirection, zDirection);
        else
            Rgbd.velocity /= 2;
    }


    void Move(float xDirection, float zDirection)
    {
        Rgbd.AddForce(new Vector3(xDirection, 0, zDirection));
        
        Vector3 velocity = Rgbd.velocity;

        if (velocity.sqrMagnitude > MaxSpeed*MaxSpeed)
        {
            float factor = MaxSpeed / velocity.magnitude;
            velocity.x = velocity.x * factor;
            velocity.z = velocity.z * factor;
        }
        
        Rgbd.velocity = velocity;
    }

}

