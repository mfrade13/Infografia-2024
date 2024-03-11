using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class EnemyController : MonoBehaviour
{
  private Rigidbody2D enemy_rgb;
  private Transform enemy_t;
  private BombermanCollider player;
  private List<Vector3> moveDirections;
  private Vector3 currentDirection;
  private Tilemap tilemap;
  private Animator animator;
  private float moveInterval = 3f;
  private float moveSpeed = 2f;
  private bool isDead = false;

  void Start()
    {
      enemy_rgb = GetComponent<Rigidbody2D>();  
      enemy_t = GetComponent<Transform>();
      animator = GetComponent<Animator>();
      player = FindObjectOfType<BombermanCollider>();
      tilemap = FindObjectOfType<Tilemap>();
      moveDirections = new List<Vector3>();
      moveDirections.Add( new Vector3(1f, 0));
      moveDirections.Add(new Vector3(-1f, 0));
      moveDirections.Add(new Vector3(0, 1f));
      moveDirections.Add(new Vector3(0, -1f));
      currentDirection = moveDirections[0];
    }


  private void FixedUpdate()
  {
    if (!isDead)
    {
      enemy_rgb.MovePosition(enemy_t.position + currentDirection * moveSpeed * Time.fixedDeltaTime);
    }
  }

  private void OnCollisionEnter2D(Collision2D collision)
  {
      if (collision.gameObject == player.gameObject)
      {
        player.die();
      }
      else
      {
        currentDirection = moveDirections[(int)Random.Range(0f, 3.9f)];
      }
  }

  private void OnTriggerEnter2D(Collider2D collision)
  {
    if (collision.gameObject.tag == "explosion"&& !isDead)
    {
      this.die();
    }
  }

  private void OnCollisionStay2D(Collision2D collision) // Change movement direction until it has a free way
  {
    if (!isDead)
    {
      Vector3Int currentCell = tilemap.WorldToCell(transform.position);
      Vector3 cellCenterPos = tilemap.GetCellCenterWorld(currentCell);
      enemy_t.position = cellCenterPos;
      currentDirection = moveDirections[(int)Random.Range(0f, 3.9f)];
    }
  }

  public void die()
  {
    this.isDead = true;
    animator.SetTrigger("hasDied");
    SceneController.instance.killEnemy();
    Invoke("DestroyObject", 0.5f);
  }

  private void DestroyObject()
  { 
    Destroy(gameObject);
  }
}
