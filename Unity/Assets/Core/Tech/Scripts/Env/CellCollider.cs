using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CellCollider : MonoBehaviour
{
    public bool ColliderEnabled = true;
    private float Timer;

    private CellProp Prop;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (ColliderEnabled && Time.time > Timer + 0.05f)
        {
            ColliderEnabled = false;
        }
    }

    public void OnCollisionEnter(Collision collision)
    {
        MovingEntity e=null;
        if (ColliderEnabled && collision.gameObject.TryGetComponent(out e))
        {
            e.Damage(1);
            Prop.HitBullet(BulletElement.Earth);
            e.Rgbd.AddForce(Random.Range(-2, 2), 100, Random.Range(-2, 2));
        }
    }

    internal void Init(CellProp prop)
    {
        Prop = prop;
        Timer = Time.time;
        ColliderEnabled = true;
    }
}
