using System.Collections;
using System.Collections.Generic;
using TMPro;
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
    public float MeteoDelayWarning = 5;
    public float MeteoDelayExplosion = 1;
    private int MeteoRandomDelay;

    public HexTilemap Map;
    public MovingEntity[] DefaultPlayers;
    public MovingEntity[] CurrentPlayers;
    public GameObject[] PlayerSpawn;
    public GameObject[] MeteoFXs;

    public float timing;

    public TextMeshProUGUI Player1Spell, Player1Life;
    public TextMeshProUGUI Player2Spell, Player2Life;
    public TextMeshProUGUI Player3Spell, Player3Life;
    public TextMeshProUGUI Player4Spell, Player4Life;

    public void Start()
    {
        Instance = this;
        CurrentPlayers = new MovingEntity[4];
        if (GameManager.Instance.Player1) 
        {
            CurrentPlayers[0] = Instantiate<MovingEntity>(DefaultPlayers[0], PlayerSpawn[0].transform);
            CurrentPlayers[0].TextElement = Player1Spell;
            CurrentPlayers[0].TextPV = Player1Life;
            PlayerCount++;
            CurrentPlayers[0].Init(Map, this);
        }
        if (GameManager.Instance.Player2)
        {
            CurrentPlayers[1] = Instantiate<MovingEntity>(DefaultPlayers[1], PlayerSpawn[1].transform);
            CurrentPlayers[1].TextElement = Player2Spell;
            CurrentPlayers[1].TextPV = Player2Life;
            PlayerCount++;
            CurrentPlayers[1].Init(Map, this);
        }
        if (GameManager.Instance.Player3)
        {
            CurrentPlayers[2] = Instantiate<MovingEntity>(DefaultPlayers[2], PlayerSpawn[2].transform);
            CurrentPlayers[2].TextElement = Player3Spell;
            CurrentPlayers[2].TextPV = Player3Life;
            PlayerCount++;
            CurrentPlayers[2].Init(Map, this);
        }
        if (GameManager.Instance.Player4)
        {
            CurrentPlayers[3] = Instantiate<MovingEntity>(DefaultPlayers[3], PlayerSpawn[3].transform);
            CurrentPlayers[3].TextElement = Player4Spell;
            CurrentPlayers[3].TextPV = Player4Life;
            PlayerCount++;
            CurrentPlayers[3].Init(Map, this);
        }

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
        GameObject MeteoFX = MeteoFXs[(int)CurrentMeteoElement];
      //  Debug.Log(CurrentMeteoElement + " " + (int)CurrentMeteoElement);
        for (int i = 0; i < CurrentMeteoCount; ++i)
        {
            Map.SpawnRandomMeteo(Random.Range(MeteoSizeMin, MeteoSizeMax), MeteoDelayWarning, MeteoDelayExplosion, CurrentMeteoElement, MeteoFX, null);
        }

        CurrentMeteoCount++;
        CurrentMeteoElement = (BulletElement)(int)Random.Range(0, 4);
        MeteoRandomDelay = Random.Range(MeteoMinDelay, MeteoMaxDelay);
        if (CurrentMeteoElement == BulletElement.Neutral) CurrentMeteoElement = BulletElement.Fire;
    }

    public void OnCharacterDie()
    {
        PlayerCount--;
        if(PlayerCount <= 1)
        {
            QuitGame();
        }
    }

    public void QuitGame()
    {
        int winner = -1;
        if (CurrentPlayers[0] != null && CurrentPlayers[0].currentLife > 0)  winner = 0;
        if (CurrentPlayers[1] != null && CurrentPlayers[1].currentLife > 0)  winner = 1;
        if (CurrentPlayers[2] != null && CurrentPlayers[2].currentLife > 0)  winner = 2;
        if (CurrentPlayers[3] != null && CurrentPlayers[3].currentLife > 0)  winner = 3;

        GameManager.Instance.EndGame(winner);
    }

}
