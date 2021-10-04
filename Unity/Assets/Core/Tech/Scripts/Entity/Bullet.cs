
using System;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    private Rigidbody Rgbd;
    private Vector2 dir;
    public float BulletSpeed = 20f;
    public float BulletDistance = 10f;
    private Vector3 PlayerPosition;

    private HexTilemap Grid;
    private bool Processed;
    private BulletElement Element;

    private MovingEntity caster;

    private int Radius;

    public void Init(MovingEntity caster, int radius, Vector3 dir, BulletElement element, HexTilemap grid)
    {
        this.dir = dir;
        this.caster = caster;
        Rgbd = this.GetComponent<Rigidbody>();
        Vector3 pos = caster.transform.position + dir;
        pos.y += 1;
        Rgbd.position = pos;
        Rgbd.velocity = dir * BulletSpeed;
        PlayerPosition = caster.transform.position;
        Element = element;
        Grid = grid;
        Processed = false;
        Radius = radius;
    }

    // Start is called before the first frame update
    void Start()
    {
    }

    public void FixedUpdate()
    {
        /*
        if (ShouldProcess())
        {
            ProcessBullet();
        }
        previousVelocity = Rgbd.velocity;
        */
    }

    public void ProcessBullet()
    {
        Processed = true;
        Vector3 pos = transform.position;
        pos.y = 0;
        HexCell c = Grid.GetCell(pos);
        
        foreach(MovingEntity e in WorldManager.Instance.CurrentPlayers)
        {
            if (e != null && c.Equals(WorldManager.Instance.Map.GetCell(e.transform.position)))
            {
                e.Damage(1);
            }
        }

        Grid.TouchCell(c, Element, Radius);
        Destroy(this.gameObject);
    }
/*
    public bool ShouldProcess()
    {
        float difference = Math.Abs(previousVelocity.x) + Math.Abs(previousVelocity.z) - Math.Abs(Rgbd.velocity.z) - Math.Abs(Rgbd.velocity.x);
        return Vector3.Distance(PlayerPosition, this.transform.position) > BulletDistance ||
            difference > 5;
    }
    */

    public void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject != caster.gameObject && !Processed)
        {
            MovingEntity player = collision.gameObject.GetComponent<MovingEntity>();
            if (player != null)
            {
                player.Damage(1);
            }
            ProcessBullet();
        }
    }
}

