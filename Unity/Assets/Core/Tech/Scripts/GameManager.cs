
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    public bool Player1;
    public bool Player2;
    public bool Player3;
    public bool Player4;
    public bool forceP1;

    public string GameScene;
    public string MenuScene;
    public string VictoryScene;

    public WorldManager World;

    public int Winner;

    public AudioSource Source;
    public AudioClip Menu;
    public AudioClip Game;
    public AudioSource Click;

    // Start is called before the first frame update
    void Start()
    {
        if(Instance != null)
        {
            Destroy(this.gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(this);
        Source.clip = Menu;
        Source.Play();
    }

    public void LoadGame(bool p1, bool p2, bool p3, bool p4)
    {
        Player1 = p1;
        Player2 = p2;
        Player3 = p3;
        Player4 = p4;
        if (forceP1)
        {
            Player1 = true;
        }
        Source.clip = Game;
        Source.Play();

        SceneManager.LoadScene(GameScene);
    }

    public void ReturnToMenu()
    {
        Source.clip = Menu;
        Source.Play();
        SceneManager.LoadScene(MenuScene);
    }

    internal void EndGame(int winner)
    {
        Winner = winner;
        SceneManager.LoadScene(VictoryScene);
    }

    public void playClick()
    {
        Click.Play();
    }
}
