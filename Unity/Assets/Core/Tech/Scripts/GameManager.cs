
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

    public int MeteoMinDelay = 10;
    
    public int MeteoMaxDelay = 20;
    private int MeteoRandomDelay;
    
    public HexTilemap Map;
    public MovingEntity[] Players;

    public float timing;

    // Start is called before the first frame update
    void Start()
    {
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
        for (int i = 0; i < CurrentMeteoCount; ++i)
        {
            Map.SpawnRandomMeteo(Random.Range(MeteoSizeMin, MeteoSizeMax), CurrentMeteoElement);
        }

        CurrentMeteoCount++;
        CurrentMeteoElement = (BulletElement)(int)Random.Range(0, 4);
        MeteoRandomDelay = Random.Range(MeteoMinDelay, MeteoMaxDelay);
        if (CurrentMeteoElement == BulletElement.Neutral) CurrentMeteoElement = BulletElement.Fire;
    }

}
