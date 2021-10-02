using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class HexTilemap : AbstractTilemap
{

	public HexCell[] Cells;
	public HexCell CellPrefab;
	public TextMeshProUGUI TextPrefab;
	private HexMesh Mesh;

	
	void Awake()
	{
		Cells = new HexCell[Height * Width];

		for (int z = 0, i = 0; z < Height; z++)
		{
			for (int x = 0; x < Width; x++)
			{
				CreateCell(x, z, i++);
			}
		}
	    Mesh = GetComponentInChildren<HexMesh>();
	}

	void Start()
	{
		Mesh.Triangulate(Cells);
	}

	void CreateCell(int x, int z, int i)
	{
		Vector3 position;
		position.x = (x + z * 0.5f - z / 2) * (HexCell.InnerRadius * 2f);
		position.y = 0f;
		position.z = z * (HexCell.OuterRadius * 1.5f);

		HexCell cell = Cells[i] = Instantiate<HexCell>(CellPrefab);
		cell.transform.SetParent(transform, false);
		cell.transform.localPosition = position;
	}

}
