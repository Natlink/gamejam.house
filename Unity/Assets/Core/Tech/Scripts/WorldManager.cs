using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class WorldManager : MonoBehaviour
{

    public static WorldManager Instance;

    public int PlayerCount;
    
    public int PlayerAlive;

    public int ElementCountOnBoard = 4;
    public int DefaultMeteoCount = 1;
    private float CurrentMeteoCount = 1.0f;
    public BulletElement CurrentMeteoElement = BulletElement.Fire;
    public int MeteoSizeMin = 1;
    public int MeteoSizeMax = 1;

    public int MeteoMinDelay = 15;

    public int MeteoMaxDelay = 25;
    public float MeteoDelayWarning = 5;
    public float MeteoDelayExplosion = 1;
    private int MeteoRandomDelay;

    public HexTilemap Map;
    public MovingEntity[] DefaultPlayers;
    public MovingEntity[] CurrentPlayers;
    public GameObject[] PlayerSpawn;
    public GameObject[] MeteoFXs;
    public GameObject[] ElementExclamation;

    public float timing;

    public Sprite[] ElementSprites;

    public Text Player1Life;
    public Text Player2Life;
    public Text Player3Life;
    public Text Player4Life;

    public Image Player1Element; 
    public Image Player2Element; 
    public Image Player3Element; 
    public Image Player4Element;

    public GameObject Player1UI;
    public GameObject Player2UI;
    public GameObject Player3UI;
    public GameObject Player4UI;

    public void Start()
    {
        Instance = this;
        CurrentPlayers = new MovingEntity[4];
        if (GameManager.Instance.Player1) 
        {
            Player1UI.SetActive(true);
            CurrentPlayers[0] = Instantiate<MovingEntity>(DefaultPlayers[0], PlayerSpawn[0].transform);
            CurrentPlayers[0].ElementSprite = Player1Element;
            CurrentPlayers[0].TextPV = Player1Life;
            PlayerCount++;
            CurrentPlayers[0].Init(Map, this, ElementSprites);
        }
        if (GameManager.Instance.Player2)
        {
            Player2UI.SetActive(true);
            CurrentPlayers[1] = Instantiate<MovingEntity>(DefaultPlayers[1], PlayerSpawn[1].transform);
            CurrentPlayers[1].ElementSprite = Player2Element;
            CurrentPlayers[1].TextPV = Player2Life;
            PlayerCount++;
            CurrentPlayers[1].Init(Map, this, ElementSprites);
        }
        if (GameManager.Instance.Player3)
        {
            Player3UI.SetActive(true);
            CurrentPlayers[2] = Instantiate<MovingEntity>(DefaultPlayers[2], PlayerSpawn[2].transform);
            CurrentPlayers[2].ElementSprite = Player3Element;
            CurrentPlayers[2].TextPV = Player3Life;
            PlayerCount++;
            CurrentPlayers[2].Init(Map, this, ElementSprites);
        }
        if (GameManager.Instance.Player4)
        {
            Player4UI.SetActive(true);
            CurrentPlayers[3] = Instantiate<MovingEntity>(DefaultPlayers[3], PlayerSpawn[3].transform);
            CurrentPlayers[3].ElementSprite = Player4Element;
            CurrentPlayers[3].TextPV = Player4Life;
            PlayerCount++;
            CurrentPlayers[3].Init(Map, this, ElementSprites);
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
        if(CurrentMeteoElement != BulletElement.Neutral)
        {
            GameObject MeteoFX = MeteoFXs[(int)CurrentMeteoElement];
            //  Debug.Log(CurrentMeteoElement + " " + (int)CurrentMeteoElement);
            bool first = true;

            GameObject warningFX = ElementExclamation[(int)CurrentMeteoElement];

            for (int i = 0; i < (int)CurrentMeteoCount; ++i)
            {
                Map.SpawnRandomMeteo(Random.Range(MeteoSizeMin, MeteoSizeMax), MeteoDelayWarning, MeteoDelayExplosion, CurrentMeteoElement, 
                    CurrentMeteoElement==BulletElement.Wind?
                        first? MeteoFX:null: 
                    MeteoFX,
                    warningFX, first);
                first = false;
            }
            CurrentMeteoCount = CurrentMeteoCount + 0.5f;
        }
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
