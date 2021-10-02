 using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingEntity : AbstractEntity
{
    public float SpeedNormal = 10;
    public float SpeedIce = 12.5f;
    public float SpeedLiquid = 6f;
    public float InertiaNormal = 0.5f;
    public float InertiaIce = 0.95f;
    public float deadZone = 0.1f;
    public float deadZoneAim = 0.15f;
    public Rigidbody Rgbd;
    private bool button = false;
    public Bullet bullet;
    private float angle = 0;

    // Start is called before the first frame update
    void Start()
    {
        Rgbd = this.GetComponent<Rigidbody>();
    }

    void FixedUpdate()
    {
        float xDirection = Input.GetAxis("Horizontal") * (Rgbd.position.x < 0 ? SpeedNormal : SpeedIce);
        float zDirection = Input.GetAxis("Vertical") * (Rgbd.position.x < 0 ? SpeedNormal : SpeedIce);
        Vector2 direction = new Vector2(xDirection, zDirection);
        bool move = deadZone * deadZone < direction.sqrMagnitude;
        xDirection = move ? xDirection : 0;
        zDirection = move ? zDirection : 0;
        Move(xDirection, zDirection);

        float xAim = Input.GetAxis("HorizontalAim");
        float zAim = Input.GetAxis("VerticalAim");
        Vector2 aim = new Vector2(xAim, zAim);
        if (deadZoneAim * deadZoneAim < aim.sqrMagnitude)
        {
            angle = Mathf.Atan2(xAim, zAim);
            this.transform.rotation = Quaternion.Euler(0, angle * 180 / Mathf.PI, 0);
            Debug.Log(xAim + ", " + zAim + ", " + angle);
        }

        if (button)
        {
            var b = Instantiate<Bullet>(bullet);
            b.Init(Rgbd.position, new Vector3(Mathf.Sin(angle), 0, Mathf.Cos(angle)));
        }
        button = false;
    }

    private void Update()
    {
        button |= Input.GetButtonDown("Fire2");
    }

    void Move(float xDirection, float zDirection)
    {
        //Rgbd.AddForce(new Vector3(xDirection, 0, zDirection));
        
        Vector3 prevVelocity = Rgbd.velocity;
        Vector3 targetVelocity = new Vector3(xDirection, 0, zDirection);
        float Inertia = (Rgbd.position.x < 0 ? InertiaNormal : InertiaIce);
        Rgbd.velocity = (prevVelocity * Inertia) + (targetVelocity * (1 - Inertia));
        
        //Debug.Log("old : " + prevVelocity + ", target : " + targetVelocity + ", new : " + Rgbd.velocity);
    }
}

