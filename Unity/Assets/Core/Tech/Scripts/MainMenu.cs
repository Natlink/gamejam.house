using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public void Play()
    {
        Debug.Log("Laucnhing Game");
        // SceneManager.LoadScene("Enzo");
    }

    public void Rules()
    {
        // SceneManager.LoadScene("Rules");
        Debug.Log("Rules Scene Holder");
    }

    public void Credits()
    {
        // SceneManager.LoadScene("Credits");
        Debug.Log("Credits Scene Holder");
    }

    public void Quit()
    {
        Application.Quit();
    }
}
