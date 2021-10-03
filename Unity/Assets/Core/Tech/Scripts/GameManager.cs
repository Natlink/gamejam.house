
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    public int ElementCountOnBoard = 4;
    public int CurrentMeteoCount = 1;
    public BulletElement CurrentMeteoElement = BulletElement.Fire;
    public int MeteoSizeMin = 0;
    public int MeteoSizeMax = 3;

    public int MeteoMinDelay = 10;
    
    public int MeteoMaxDelay = 20;
    private int MeteoRandomDelay;
    
    public HexTilemap Map;
    public MovingEntity[] Players;

    public float timing;

    // Start is called before the first frame update
    void Start()
    {
        Instance = this;
        for(int x = 0; x < ElementCountOnBoard; ++x)
        {
            Map.SpawnRandomElement();
        }
        MeteoRandomDelay = Random.Range(MeteoMinDelay, MeteoMaxDelay);
    }

    // Update is called once per frame
    void Update()
    {
        if(Time.time > timing + MeteoRandomDelay)
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
        MeteoRandomDelay = Random.Range(MeteoMinDelay, MeteoMaxDelay);
        if (CurrentMeteoElement == BulletElement.Neutral) CurrentMeteoElement = BulletElement.Fire;
    }

}
