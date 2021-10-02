
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

    private Vector3 previousVelocity;
    
    public void Init(Vector3 player, Vector3 dir, BulletElement element, HexTilemap grid)
    {
        this.dir = dir;
        Rgbd = this.GetComponent<Rigidbody>();
        Vector3 pos = player + dir;
        pos.y += 1;
        Rgbd.position = pos;
        Rgbd.velocity = dir * BulletSpeed;
        PlayerPosition = player;
        Element = element;
        Grid = grid;
    }

    // Start is called before the first frame update
    void Start()
    {
    }

    public void FixedUpdate()
    {
        
        if (ShouldProcess())
        {
            Debug.Log( (Math.Abs(previousVelocity.x) + Math.Abs(previousVelocity.z)) +" " + (Math.Abs(Rgbd.velocity.z) - Math.Abs(Rgbd.velocity.x)));
            ProcessBullet();
        }
        previousVelocity = Rgbd.velocity;
    }

    public void ProcessBullet()
    {
        Processed = true;
        Grid.TouchCell(Grid.GetCell(transform.position), Element);
        Destroy(this.gameObject);
    }

    public bool ShouldProcess()
    {
        float difference = Math.Abs(previousVelocity.x) + Math.Abs(previousVelocity.z) - Math.Abs(Rgbd.velocity.z) - Math.Abs(Rgbd.velocity.x);
        return Vector3.Distance(PlayerPosition, this.transform.position) > BulletDistance ||
            difference > 5;
    }
}

