using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class Bomb : MonoBehaviour
{
  private Rigidbody2D bomb_rgb;
  private BoxCollider2D bomb_collider;
  private BombermanCollider player;
  private Tilemap tilemap;

  public float countdown = 2f;
    void Start()
    {
        bomb_rgb = GetComponent<Rigidbody2D>();
        bomb_collider = GetComponent<BoxCollider2D>();
        player = FindObjectOfType<BombermanCollider>();
        tilemap = FindObjectOfType<Tilemap>();
    }


    void Update()
    {
       countdown -= Time.deltaTime;  
    
      if (bomb_collider.enabled == false && player.getCurrentCell() != tilemap.WorldToCell(transform.position))
      {
        bomb_collider.enabled = true;
      }
      if (countdown <= 0f )
      {
        FindObjectOfType<MapDestroyer>().Explode(transform.position); //singleton
        Destroy(gameObject);
      }
    }
}
