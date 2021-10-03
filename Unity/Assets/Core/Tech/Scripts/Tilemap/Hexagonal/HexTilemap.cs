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


	public List<ElementObject> Elements;
	
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
        {
			c.Neighboors = new List<HexCell>();
			var co = c.coordinates;
			int xShift = co.Z / 2;
			int max = Width * Height, x = 0, z = 0;
			c.Neighboors.Add((x = co.X - 1 + xShift) >= 0 && x < Width ? Cells[x + co.Z * Width] : null);
			c.Neighboors.Add((x = co.X + 1 + xShift) >= 0 && x < Width ? Cells[x + co.Z * Width] : null);

			int leftX = (co.Z % 2 == 0) ? co.X + xShift - 1 : co.X + xShift;
			c.Neighboors.Add((x = leftX) >= 0 && x < Width && (z = co.Z - 1) >= 0 && z < Height ? Cells[x + z * Width] : null);
			c.Neighboors.Add((x = leftX + 1) >= 0 && x < Width && (z = co.Z - 1) >= 0 && z < Height ? Cells[x + z * Width] : null);

			c.Neighboors.Add((x = leftX) >= 0 && x < Width && (z = co.Z + 1) >= 0 && z < Height ? Cells[x + z * Width] : null);
			c.Neighboors.Add((x = leftX + 1) >= 0 && x < Width && (z = co.Z + 1) >= 0 && z < Height ? Cells[x + z * Width] : null);
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
		position.x = (x + (z % 2) * 0.5f) * (HexCell.InnerRadius * 2f);
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
			TouchCell(GetCell(hit.point), Enums.CurrentBullet, 1);
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
		int iX = coordinates.X + coordinates.Z / 2;
		int iZ = coordinates.Z;
		return iX >= 0 && iX < Width
			&& iZ >= 0 && iZ < Height
			? Cells[iX + iZ * Width] : null;
	}

	public void SpawnRandomElement()
    {
		HexCell c = Cells[Random.Range(0, (Width*Height)-1)];
		int elem = Random.Range(0, 4);

		ElementObject o = Instantiate(Elements[elem], c.transform);
		o.Map = this;
		o.transform.position = new Vector3(o.transform.position.x, 0.15f, o.transform.position.z);
	}


	internal void SpawnRandomMeteo(int meteoSize, BulletElement element)
	{
		HexCell c = Cells[Random.Range(0, (Width * Height) - 1)];
		TouchCell(c, element, meteoSize);
	}

}
