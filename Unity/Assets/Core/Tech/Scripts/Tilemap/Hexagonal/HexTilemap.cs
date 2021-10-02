using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class HexTilemap : AbstractTilemap
{

	public Color defaultColor = Color.white;
	public Color touchedColor = Color.magenta;

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
		cell.coordinates = HexCoordinates.FromOffsetCoordinates(x, z);

		cell.color = defaultColor;
	}

	void Update()
	{
		if (Input.GetMouseButtonDown(0))
		{
			HandleInput();
		}
	}

	void HandleInput()
	{
		Ray inputRay = Camera.main.ScreenPointToRay(Input.mousePosition);
		RaycastHit hit;
		if (Physics.Raycast(inputRay, out hit))
		{
			TouchCell(GetCell(hit.point), Test.CurrentBullet);
		}
	}

	public void TouchCell(HexCell cell, BulletElement element)
	{
		if (cell == null) return;

		cell.HitCell(element);
		Mesh.Triangulate(Cells);
	}

	public HexCell GetCell(Vector3 position)
    {
		transform.InverseTransformPoint(position);
		HexCoordinates coordinates = HexCoordinates.FromPosition(position);
		int index = coordinates.X + coordinates.Z * Width + coordinates.Z / 2;
		return index > 0 && index < Width * Height ?
				Cells[index] : null;
	}
}
