using UnityEngine;
using UnityEngine.Tilemaps;

public class BombSpawner : MonoBehaviour
{
  public Tilemap tilemap;
  public GameObject bomb;
  public BombermanCollider player;

    void Start()
    {
        
    }

    void Update()
    {
      if (Input.GetKeyDown(KeyCode.Space))
      {
      Vector3 cellCenterPos = tilemap.GetCellCenterWorld(player.getCurrentCell());

        Instantiate(bomb, cellCenterPos, Quaternion.identity);
      }
  }
}
