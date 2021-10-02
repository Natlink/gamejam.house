using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class HexCell : MonoBehaviour
{

    public const float OuterRadius = 0.5f;
    public const float InnerRadius = OuterRadius * 0.866025404f;

    Mesh HexMesh;
    List<Vector3> Vertices;
    List<int> Triangles;

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

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}