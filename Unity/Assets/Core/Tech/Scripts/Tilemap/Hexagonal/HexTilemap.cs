using System.Collections;
using System.Collections.Generic;
using System.Linq;
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
		foreach(HexCell c in Cells)
        { //0 droite 1 gauche
			c.Neighboors = new List<HexCell>();
			var co = c.coordinates;
			int max = Width * Height, cur = 0;
			c.Neighboors.Add( (cur = ((co.X - 1) + co.Z / 2) + (co.Z * Width)) >= 0 && cur < max ? Cells[cur] : null);
			c.Neighboors.Add((cur = ((co.X + 1) + co.Z / 2) + (co.Z * Width)) >= 0 && cur < max ? Cells[cur] : null);
	
			if(co.Z % 2 == 0)
			{
				c.Neighboors.Add((cur = ((co.X - 1) + co.Z / 2) + ((co.Z - 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);
				c.Neighboors.Add((cur = ((co.X) + co.Z / 2) + ((co.Z - 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);

				c.Neighboors.Add((cur = ((co.X - 1) + co.Z / 2) + ((co.Z + 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);
				c.Neighboors.Add((cur = ((co.X) + co.Z / 2) + ((co.Z + 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);
			}
			else
			{
				c.Neighboors.Add((cur = ((co.X) + co.Z / 2) + ((co.Z - 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);
				c.Neighboors.Add((cur = ((co.X +1 ) + co.Z / 2) + ((co.Z - 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);

				c.Neighboors.Add((cur = ((co.X) + co.Z / 2) + ((co.Z + 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);
				c.Neighboors.Add((cur = ((co.X +1) + co.Z / 2) + ((co.Z + 1) * Width)) >= 0 && cur < max ? Cells[cur] : null);
			}
			/*
			c.Neighboors.Add(Cells[co.X + (co.Z * Height)]);
			c.Neighboors.Add(Cells[co.X+1 + (co.Z * Height)]);
			*/
			if (co.Z % 2 == 0)
            {

            }

			/*
			if (co.Z%2 != 0)
            {
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X, co.Z -1)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X+1, co.Z-1)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X-1, co.Z)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X+1, co.Z)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X, co.Z+1)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X+1, co.Z+1)));
            }
            else
            {
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X-1, co.Z - 1)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X, co.Z - 1)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X - 1, co.Z)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X + 1, co.Z)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X-1, co.Z + 1)));
				c.Neighboors.Add(GetCell(HexCoordinates.FromOffsetCoordinates(co.X, co.Z + 1)));
			}
			*/
			c.Neighboors.RemoveAll((c) => c == null);
        }
	    Mesh = GetComponentInChildren<HexMesh>();
	}

	public List<HexCell> GetNeighboors(int range, HexCell center)
    {
		List<HexCell> result = new List<HexCell>() { center };
		for(int i = 0; i < range; ++i)
		{
			List<HexCell> resultTmp = new List<HexCell>();
			foreach (HexCell c in result)
			{
				resultTmp.AddRange(c.Neighboors);
			}
			result.AddRange(resultTmp);
			result = result.Distinct().ToList();
		}
		return result;
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
		cell.name = cell.coordinates.ToString();
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
			TouchCell(GetCell(hit.point), Test.CurrentBullet, 1);
		}
	}

	public void TouchCell(HexCell cell, BulletElement element, int size)
	{
		if (cell == null) return;
		foreach(HexCell c in GetNeighboors(size, cell))
		{
			c.HitCell(element);
		}
		Mesh.Triangulate(Cells);
	}

	public HexCell GetCell(Vector3 position)
    {
		transform.InverseTransformPoint(position);
		return GetCell(HexCoordinates.FromPosition(position));
	}

	public HexCell GetCell(HexCoordinates coordinates)
    {
		int index = coordinates.X + coordinates.Z * Width + coordinates.Z / 2;
		return index > 0 && index < Width * Height ?
				Cells[index] : null;
	}
}
