using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LobbyMenu : MonoBehaviour
{

    public TextMeshProUGUI Player1Text;
    public TextMeshProUGUI Player2Text;
    public TextMeshProUGUI Player3Text;
    public TextMeshProUGUI Player4Text;

    public bool Player1;
    public bool Player2;
    public bool Player3;
    public bool Player4;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Player1Fire1"))
        {
            Player1 = !Player1;
            Player1Text.text = "Player 1" + (Player1?"Present":"away");
        }

        if (Input.GetButtonDown("Player2Fire1"))
        {
            Player2 = !Player2;
            Player1Text.text = "Player 2" + (Player2 ? "Present" : "away");
        }

        if (Input.GetButtonDown("Player3Fire1"))
        {
            Player3 = !Player3;
            Player1Text.text = "Player 3" + (Player3 ? "Present" : "away");
        }

        if (Input.GetButtonDown("Player4Fire1"))
        {
            Player4 = !Player4;
            Player1Text.text = "Player 4" + (Player4 ? "Present" : "away");
        }
    }

    public void Play()
    {
        GameManager.Instance.LoadGame(Player1, Player2, Player3, Player4);
    }

    public void Quit()
    {
        SceneManager.LoadScene("MainMenu");
    }
}
