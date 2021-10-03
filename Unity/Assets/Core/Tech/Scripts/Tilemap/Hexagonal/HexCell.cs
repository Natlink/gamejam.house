using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class HexCell : MonoBehaviour
{
    public Color color;

    public const float OuterRadius = 1f;
    public const float InnerRadius = OuterRadius * 0.866025404f;

    public HexCoordinates coordinates;
    public Mesh HexMesh;
    public List<Vector3> Vertices;
    public List<int> Triangles;

    public CellProp Prop;

    void Awake()
    {
        GetComponent<MeshFilter>().mesh = HexMesh = new Mesh();
        HexMesh.name = "Hex Mesh";
        Vertices = new List<Vector3>();
        Triangles = new List<int>();
    }

    public static Vector3[] Corners = {
        new Vector3(0f, 0f, OuterRadius),
        new Vector3(InnerRadius, 0f, 0.5f * OuterRadius),
        new Vector3(InnerRadius, 0f, -0.5f * OuterRadius),
        new Vector3(0f, 0f, -OuterRadius),
        new Vector3(-InnerRadius, 0f, -0.5f * OuterRadius),
        new Vector3(-InnerRadius, 0f, 0.5f * OuterRadius),
        new Vector3(0f, 0f, OuterRadius)
    };

    public void HitCell(BulletElement bullet)
    {
        Prop.HitBullet(bullet);
        switch (Prop.CurrentElement)
        {
            case CellElement.Flamme:
                color = Color.red;
                break;
            case CellElement.Rock:
                color = Color.green;
                break;
            case CellElement.Wet:
                color = Color.blue;
                break;
            case CellElement.Lava:
                color = Color.yellow;
                break;
            case CellElement.Ice:
                color = Color.cyan;
                break;
            case CellElement.Neutral:
                color = Color.white;
                break;
        }
        
    }

}

[Serializable]
public struct HexCoordinates
{

    [SerializeField]
    public int X { get; private set; }

    [SerializeField]
    public int Z { get; private set; }
    public int Y
    {
        get
        {
            return -X - Z;
        }
    }

    public HexCoordinates(int x, int z)
    {
        this.X = x;
        this.Z = z;
    }

    public static HexCoordinates FromOffsetCoordinates(int x, int z)
    {
        return new HexCoordinates(x - z / 2, z);
    }
    public static HexCoordinates FromPosition(Vector3 position)
    {
        float x = position.x / (HexCell.InnerRadius * 2f);
        float y = -x;
        float offset = position.z / (HexCell.OuterRadius * 3f);
        x -= offset;
        y -= offset;
        int iX = Mathf.RoundToInt(x);
        int iY = Mathf.RoundToInt(y);
        int iZ = Mathf.RoundToInt(-x - y);
        if (iX + iY + iZ != 0)
        {
            float dX = Mathf.Abs(x - iX);
            float dY = Mathf.Abs(y - iY);
            float dZ = Mathf.Abs(-x - y - iZ);

            if (dX > dY && dX > dZ)
            {
                iX = -iY - iZ;
            }
            else if (dZ > dY)
            {
                iZ = -iX - iY;
            }
        }
        return new HexCoordinates(iX, iZ);
    }

    public override string ToString()
    {
        return "(" +
            X.ToString() + ", " + Y.ToString() + ", " + Z.ToString() + ")";
    }

    public string ToStringOnSeparateLines()
    {
        return X.ToString() + "\n" + Y.ToString() + "\n" + Z.ToString();
    }
}