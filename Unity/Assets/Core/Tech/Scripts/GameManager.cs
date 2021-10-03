using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public int ElementCountOnBoard = 4;
    public int CurrentMeteoCount = 1;
    public BulletElement CurrentMeteoElement = BulletElement.Fire;
    public int MeteoSizeMin = 0;
    public int MeteoSizeMax = 3;

    public int MeteoDelay = 5;
    
    public HexTilemap Map;
    public MovingEntity[] Players;

    public float timing;

    // Start is called before the first frame update
    void Start()
    {
        for(int x = 0; x < ElementCountOnBoard; ++x)
        {
          //  Map.SpawnRandomElement();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(Time.time > timing + MeteoDelay)
        {
            timing = Time.time;
            Meteo();
        }
    }

    void Meteo()
    {
        switch (CurrentMeteoElement)
        {
            case BulletElement.Water:
                for (int i = 0; i < CurrentMeteoCount * 6; ++i)
                {
                    Map.SpawnRandomMeteo(0, CurrentMeteoElement);
                }
                break;
            default:
                for (int i = 0; i < CurrentMeteoCount; ++i)
                {
                    Map.SpawnRandomMeteo(Random.Range(MeteoSizeMin, MeteoSizeMax), CurrentMeteoElement);
                }
                break;
        }
        CurrentMeteoCount++;
        CurrentMeteoElement = (BulletElement)(int)Random.Range(0, 4);
        if (CurrentMeteoElement == BulletElement.Neutral) CurrentMeteoElement = BulletElement.Fire;
    }

}
