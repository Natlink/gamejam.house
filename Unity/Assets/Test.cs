using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Test : MonoBehaviour
{
    public TextMeshProUGUI Text;
    public static BulletElement CurrentBullet;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown("joystick button 0"))
        {
            CurrentBullet = BulletElement.Fire;
            Text.text = CurrentBullet+"";
        }
        if (Input.GetKeyDown("joystick button 1"))
        {
            CurrentBullet = BulletElement.Wind;
            Text.text = CurrentBullet + "";
        }
        if (Input.GetKeyDown("joystick button 2"))
        {
            CurrentBullet = BulletElement.Earth;
            Text.text = CurrentBullet + "";
        }
        if (Input.GetKeyDown("joystick button 3"))
        {
            CurrentBullet = BulletElement.Water;
            Text.text = CurrentBullet + "";
        }
    }
}

public enum BulletElement
{
    Fire,
    Wind,
    Earth,
    Water,
    Neutral
}

public enum CellElement
{
    Flamme,
    Rock,
    Wet,
    Lava,
    Ice,
    Neutral,
}