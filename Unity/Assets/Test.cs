using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        foreach(var a in this.GetComponents(typeof(TextMeshPro)))
        {
            Debug.Log(a.ToString());
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
