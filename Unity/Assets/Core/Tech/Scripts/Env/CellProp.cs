using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CellProp : MonoBehaviour
{
    public CellElement CurrentElement;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void HitBullet(BulletElement bullet)
    {
        switch (bullet)
        {
            case BulletElement.Fire:
                SwitchToFire();
                break;
            case BulletElement.Wind:
                SwitchToWind();
                break;
            case BulletElement.Earth:
                SwitchToEarth();
                break;
            case BulletElement.Water:
                SwitchToWater();
                break;
            case BulletElement.Neutral:
                SwitchToNeutral();
                break;
        }
    }

    private void SwitchToNeutral()
    {
        CurrentElement = CellElement.Neutral;
    }

    private void SwitchToWater()
    {
        switch (CurrentElement)
        {
            case CellElement.Flamme:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Rock:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Wet:
                break;
            case CellElement.Lava:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Ice:
                break;
            case CellElement.Neutral:
                CurrentElement = CellElement.Wet;
                break;
        }
    }

    private void SwitchToEarth()
    {
        switch (CurrentElement)
        {
            case CellElement.Flamme:
                CurrentElement = CellElement.Lava;
                break;
            case CellElement.Rock:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Wet:
                CurrentElement = CellElement.Rock;
                break;
            case CellElement.Lava:
                Explosion();
                break;
            case CellElement.Ice:
                CurrentElement = CellElement.Rock;
                break;
            case CellElement.Neutral:
                CurrentElement = CellElement.Rock;
                break;
        }
    }

    private void SwitchToWind()
    {
        switch (CurrentElement)
        {
            case CellElement.Flamme:
                Explosion();
                break;
            case CellElement.Rock:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Wet:
                CurrentElement = CellElement.Ice;
                break;
            case CellElement.Lava:
                CurrentElement = CellElement.Lava;
                break;
            case CellElement.Ice:
                break;
            case CellElement.Neutral:
                break;
        }
    }

    private void Explosion()
    {
    }

    private void SwitchToFire()
    {

        switch (CurrentElement)
        {
            case CellElement.Flamme:
                break;
            case CellElement.Rock:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Wet:
                CurrentElement = CellElement.Neutral;
                break;
            case CellElement.Lava:
                break;
            case CellElement.Ice:
                CurrentElement = CellElement.Wet;
                break;
            case CellElement.Neutral:
                CurrentElement = CellElement.Flamme;
                break;
        }
    }
}
