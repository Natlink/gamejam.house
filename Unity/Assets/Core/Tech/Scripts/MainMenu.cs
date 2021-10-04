using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public void Play()
    {
        GameManager.Instance.playClick();
        SceneManager.LoadScene("Lobby");
    }

    public void Rules()
    {
        GameManager.Instance.playClick();
        SceneManager.LoadScene("Rules");
    }

    public void Credits()
    {
        GameManager.Instance.playClick();
        SceneManager.LoadScene("Credits");
    }

    public void Back()
    {
        GameManager.Instance.playClick();
        SceneManager.LoadScene("MainMenu");
    }

    public void Quit()
    {
        GameManager.Instance.playClick();
        Application.Quit();
    }
}
