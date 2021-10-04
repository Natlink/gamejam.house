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

    public void OnTriggerEnter(Collider collision)
    {
        MovingEntity entity = collision.gameObject.GetComponent<MovingEntity>();
        if (entity != null && entity.CanPickElement(Element))
        {
            Destroy();
            return;
        }

        CellCollider rock = collision.gameObject.GetComponent<CellCollider>();
        if(rock == null)
        {
            rock = collision.gameObject.GetComponentInChildren<CellCollider>();
        }
        if (rock == null)
        {
            rock = collision.gameObject.GetComponentInParent<CellCollider>();
        }
        if (rock != null)
        {
            Destroy();
            return;
        }

    }

    public void Destroy()
    {
        Map.SpawnRandomElement();
        Destroy(this.gameObject);
    }
}
