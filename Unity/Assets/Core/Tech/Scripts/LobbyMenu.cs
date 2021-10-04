using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LobbyMenu : MonoBehaviour
{

    public Image PlayerImage1;
    public Image PlayerImage2;
    public Image PlayerImage3;
    public Image PlayerImage4;

    public bool Player1;
    public bool Player2;
    public bool Player3;
    public bool Player4;

    public Color NormalColor;
    public Color GreyColor;

    // Start is called before the first frame update
    void Start()
    {
        //PlayerImage1.color = Player1 ? NormalColor : GreyColor;
        //PlayerImage2.color = Player2 ? NormalColor : GreyColor;
        //PlayerImage3.color = Player3 ? NormalColor : GreyColor;
        //PlayerImage4.color = Player4 ? NormalColor : GreyColor;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Player1Fire1")|| Input.GetButtonDown("Player1Fire2"))
        {
            Player1 = !Player1;
            PlayerImage1.color = Player1 ? NormalColor : GreyColor;
        }

        if (Input.GetButtonDown("Player2Fire1")|| Input.GetButtonDown("Player2Fire2"))
        {
            Player2 = !Player2;
            PlayerImage2.color = Player2 ? NormalColor : GreyColor;
        }

        if (Input.GetButtonDown("Player3Fire1")|| Input.GetButtonDown("Player3Fire2"))
        {
            Player3 = !Player3;
            PlayerImage3.color = Player3 ? NormalColor : GreyColor;
        }

        if (Input.GetButtonDown("Player4Fire1") || Input.GetButtonDown("Player4Fire2"))
        {
            Player4 = !Player4;
            PlayerImage4.color = Player4 ? NormalColor : GreyColor;
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
