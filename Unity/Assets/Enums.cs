using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Enums : MonoBehaviour
{
    public static BulletElement CurrentBullet = BulletElement.Neutral;

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