using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class MapDestroyer : MonoBehaviour
{
  public Tilemap tilemap;
  public Tile concreteTile;
  public Tile brickTile;
  public GameObject explosionPrefab;


  public void Explode(Vector2 worldPos) //power ups
  {
    Vector3Int originCell =  tilemap.WorldToCell(worldPos);
    ExplodeCell(originCell);
    ExplodeCell(originCell + new Vector3Int(1,0,0));
    ExplodeCell(originCell + new Vector3Int(-1, 0, 0));
    ExplodeCell(originCell + new Vector3Int(0, 1, 0));
    ExplodeCell(originCell + new Vector3Int(0, -1, 0));
  }

  private bool ExplodeCell (Vector3Int cell)
  {
    Tile tile= tilemap.GetTile<Tile>(cell);
    if (tile == concreteTile)
    {
      return false;
    }

    if (tile == brickTile)
    {
      tilemap.SetTile(cell, null);
    }

    Vector3 pos = tilemap.GetCellCenterWorld (cell);
    GameObject explosion = Instantiate(explosionPrefab, pos, Quaternion.identity);

    return true;
  }
}
