using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class VictoryMenu : MonoBehaviour
{

    public Sprite VictorySpriteNoOne;
    public Sprite VictorySpriteP1;
    public Sprite VictorySpriteP2;
    public Sprite VictorySpriteP3;
    public Sprite VictorySpriteP4;

    public Image Background;

    // Start is called before the first frame update
    void Start()
    {
        Sprite s = null;
        switch (GameManager.Instance.Winner)
        {
            default: s = VictorySpriteNoOne; break;
            case 0: s = VictorySpriteP1; break;
            case 1: s = VictorySpriteP2; break;
            case 2: s = VictorySpriteP3; break;
            case 3: s = VictorySpriteP4; break;
        }
        Background.sprite = s;
    }

    public void Exit()
    {
        GameManager.Instance.playClick();
        GameManager.Instance.ReturnToMenu(); 
    }
}
