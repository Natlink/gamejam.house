
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

    public string GameScene;
    public string MenuScene;

    public WorldManager World;

    // Start is called before the first frame update
    void Start()
    {
        Instance = this;
        DontDestroyOnLoad(this);
    }

    public void LoadGame(bool p1, bool p2, bool p3, bool p4)
    {
        Player1 = p1;
        Player2 = p2;
        Player3 = p3;
        Player4 = p4;
        SceneManager.LoadScene(GameScene);
    }

    void ReturnToMenu()
    {
        SceneManager.LoadScene(MenuScene);
    }


}
