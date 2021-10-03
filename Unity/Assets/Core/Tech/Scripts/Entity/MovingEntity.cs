 using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingEntity : AbstractEntity
{
    public String moveX = "Player1MoveX";
    public String moveZ = "Player1MoveZ";
    public String aimX = "Player1AimX";
    public String aimZ = "Player1AimZ";
    public String fire1 = "Player1Fire1";
    public String fire2 = "Player1Fire2";
    public String fire3 = "Player1Fire3";
    public float SpeedNormal = 10;
    public float SpeedIce = 12.5f;
    public float SpeedLiquid = 8f;
    public float InertiaNormal = 0.5f;
    public float InertiaIce = 0.95f;
    public float deadZone = 0.1f;
    public float deadZoneAim = 0.15f;
    public Rigidbody Rgbd;
    public HexTilemap map;
    private bool button = false;
    public Bullet bullet;
    private float angle = 0;

    public float reloadTimer = 3.0f; 
    private bool canShoot = true;

    public int radius;

    // Start is called before the first frame update
    void Start()
    {
        Rgbd = this.GetComponent<Rigidbody>();
    }

    void FixedUpdate()
    {
        Move();

        float xAim = Input.GetAxis(aimX);
        float zAim = Input.GetAxis(aimZ);
        Vector2 aim = new Vector2(xAim, zAim);
        if (deadZoneAim * deadZoneAim < aim.sqrMagnitude)
        {
            angle = Mathf.Atan2(xAim, zAim);
            this.transform.rotation = Quaternion.Euler(0, angle * 180 / Mathf.PI, 0);
            // Debug.Log(xAim + ", " + zAim + ", " + angle);
        }

        if (button && canShoot)
        {
            var b = Instantiate<Bullet>(bullet);
            b.Init(this, radius, new Vector3(Mathf.Sin(angle), 0, Mathf.Cos(angle)), Test.CurrentBullet, map);
            canShoot = false;
            StartCoroutine("Reload");
        }
        button = false;
    }

    private void Update()
    {
        button |= Input.GetButtonDown(fire1);
    }

    IEnumerator Reload()
    {
        yield return new WaitForSeconds(reloadTimer);
        canShoot = true;
        yield return null;
    }

    void Move()
    {
        HexCell cell = map.GetCell(Rgbd.position);
        CellElement elem = cell.Prop.CurrentElement;
        bool onIce = cell != null && elem == CellElement.Ice;
        bool inLiquid = cell != null && (elem == CellElement.Lava || elem == CellElement.Wet);
        float speed = onIce ? SpeedIce : inLiquid ? SpeedLiquid : SpeedNormal;
        float xDirection = Input.GetAxis(moveX) * speed;
        float zDirection = Input.GetAxis(moveZ) * speed;
        Vector2 direction = new Vector2(xDirection, zDirection);
        bool move = deadZone * deadZone < direction.sqrMagnitude;
        xDirection = move ? xDirection : 0;
        zDirection = move ? zDirection : 0;
        //Rgbd.AddForce(new Vector3(xDirection, 0, zDirection));

        Vector3 prevVelocity = Rgbd.velocity;
        Vector3 targetVelocity = new Vector3(xDirection, 0, zDirection);
        float Inertia = (onIce ? InertiaIce : InertiaNormal);
        Rgbd.velocity = (prevVelocity * Inertia) + (targetVelocity * (1 - Inertia));
        
        // Debug.Log("old : " + prevVelocity + ", target : " + targetVelocity + ", new : " + Rgbd.velocity);
    }
}

