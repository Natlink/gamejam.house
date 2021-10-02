using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexTilemap : AbstractTilemap
{

	public HexCell[] Cells;
	public HexCell CellPrefab;

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
	}

	void CreateCell(int x, int z, int i)
	{
		Vector3 position;
		position.x = x * 10f;
		position.y = 0f;
		position.z = z * 10f;

		HexCell cell = Cells[i] = Instantiate<HexCell>(CellPrefab);
		cell.transform.SetParent(transform, false);
		cell.transform.localPosition = position;
	}

	// Start is called before the first frame update
	void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
