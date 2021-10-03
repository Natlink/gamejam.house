using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public int ElementCountOnBoard = 4;
    public int CurrentMeteoCount = 1;
    public HexTilemap Map;
    public MovingEntity[] Players;

    // Start is called before the first frame update
    void Start()
    {
        for(int x = 0; x < ElementCountOnBoard; ++x)
        {

        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

}
