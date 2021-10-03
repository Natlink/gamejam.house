using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldManager : MonoBehaviour
{

    public static WorldManager Instance;

    public int PlayerCount;

    public int PlayerAlive;

    public int ElementCountOnBoard = 4;
    public int DefaultMeteoCount = 1;
    private int CurrentMeteoCount = 1;
    public BulletElement CurrentMeteoElement = BulletElement.Fire;
    public int MeteoSizeMin = 0;
    public int MeteoSizeMax = 3;

    public int MeteoMinDelay = 10;

    public int MeteoMaxDelay = 20;
    private int MeteoRandomDelay;

    public HexTilemap Map;
    public MovingEntity[] DefaultPlayers;
    public MovingEntity[] CurrentPlayers;
    public GameObject[] PlayerSpawn;

    public float timing;


    public void Start()
    {
        Instance = this;
        CurrentPlayers = new MovingEntity[4];
        if (GameManager.Instance.Player1) CurrentPlayers[0] = Instantiate<MovingEntity>(DefaultPlayers[0], PlayerSpawn[0].transform);
        if (GameManager.Instance.Player2) CurrentPlayers[1] = Instantiate<MovingEntity>(DefaultPlayers[1], PlayerSpawn[1].transform);
        if (GameManager.Instance.Player3) CurrentPlayers[2] = Instantiate<MovingEntity>(DefaultPlayers[2], PlayerSpawn[2].transform);
        if (GameManager.Instance.Player4) CurrentPlayers[3] = Instantiate<MovingEntity>(DefaultPlayers[3], PlayerSpawn[3].transform);

        PlayerCount = (CurrentPlayers[0] == null ? 0 : 1) + (CurrentPlayers[1] == null ? 0 : 1) + (CurrentPlayers[2] == null ? 0 : 1) + (CurrentPlayers[3] == null ? 0 : 1);

        CurrentMeteoCount = DefaultMeteoCount;
        for (int x = 0; x < ElementCountOnBoard; ++x)
        {
            Map.SpawnRandomElement();
        }
        MeteoRandomDelay = Random.Range(MeteoMinDelay, MeteoMaxDelay);
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time > timing + MeteoRandomDelay)
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
