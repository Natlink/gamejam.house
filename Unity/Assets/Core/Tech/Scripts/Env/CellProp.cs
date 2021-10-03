using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CellProp : MonoBehaviour
{
    public CellElement PreviousElement;
    public CellElement CurrentElement;
    private Material Material;

    private List<string> elems = new List<string>() { "_Flammes", "_Glace", "_Lave", "_Flaque", "_Rocher" };
    private int toSwapIndex = -1;

    public GameObject[] FXs;

    void Start()
    {
        Material = GetComponent<MeshRenderer>().material;
    }

    private float timeElapsed;
    public float lerpDuration = 1;

    public void HitBullet(BulletElement bullet)
    {
        Material = GetComponent<MeshRenderer>().material;
        var _previous = CurrentElement;
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
        if(_previous != CurrentElement)
        {
            PreviousElement = _previous;
            switch (CurrentElement)
            {
                case CellElement.Flamme:
                    toSwapIndex = 0;
                    break;
                case CellElement.Rock:
                    toSwapIndex = 4;
                    break;
                case CellElement.Wet:
                    toSwapIndex = 3;
                    break;
                case CellElement.Lava:
                    toSwapIndex = 2;
                    break;
                case CellElement.Ice:
                    toSwapIndex = 1;
                    break;
                case CellElement.Neutral:
                    toSwapIndex = -1;
                    break;
            }
        }
        if(toSwapIndex != -1)
        {
            string elem = elems[toSwapIndex];
            foreach (GameObject o in FXs) o.SetActive(false);

            FXs[toSwapIndex].SetActive(true);

            foreach (string s in elems)
            {
                if (s.Equals(elem))
                {
                    Material.SetFloat(elem, 1);
                }
                else
                {
                    Material.SetFloat(s, 0);
                }
            }
        }
        else{
            foreach (GameObject o in FXs) o.SetActive(false);
            foreach (string s in elems)
            {
                Material.SetFloat(s, 0);
            }
        }
    }

    private void SwitchToNeutral()
    {
        CurrentElement = CellElement.Neutral;
        toSwapIndex = -1;
    }
    //{ "_Flammes", "_Glace", "_Lave",, "_Rocher",  "_Flaque" };
    private void SwitchToWater()
    {
        switch (CurrentElement)
        {
            case CellElement.Flamme:
            case CellElement.Rock:
            case CellElement.Lava:
                CurrentElement = CellElement.Neutral;
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
                CurrentElement = CellElement.Neutral;
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
