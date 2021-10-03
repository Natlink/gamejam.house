using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ElementObject : MonoBehaviour
{
    public BulletElement Element;
    public HexTilemap Map;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void OnCollisionEnter(Collision collision)
    {
        MovingEntity entity = collision.gameObject.GetComponent<MovingEntity>();
        if (entity != null)
        {
            if (entity.CanPickElement(Element)) { }

        }
        Map.SpawnRandomElement();
        Destroy(this.gameObject);
    }

}
