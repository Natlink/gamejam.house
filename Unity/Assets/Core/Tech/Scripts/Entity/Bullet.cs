
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public Rigidbody Rgbd;
    private Vector2 dir;

    public void Init(Vector3 player, Vector3 dir)
    {
        this.dir = dir;
        Rgbd = this.GetComponent<Rigidbody>();
        Vector3 pos = player + dir;
        pos.y += 1;
        Rgbd.position = pos;
        Rgbd.velocity = dir * 10;
    }

    // Start is called before the first frame update
    void Start()
    {
    }
 }