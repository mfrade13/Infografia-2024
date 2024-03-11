using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;
using UnityEngine.UIElements;

public class BombermanCollider : MonoBehaviour
{
  public float moveSpeed = 2f;
  private bool isDead = false;
  private CapsuleCollider2D capsuleCollider;
  Transform bomberman_t;
  Animator animator;
  Rigidbody2D bomberman_rgb;
  Vector3 moveDirection;
  public Tilemap tilemap;

  void Start()
    {
        bomberman_t = GetComponent<Transform>();
        animator = GetComponent<Animator>();
        bomberman_rgb = bomberman_t.GetComponent<Rigidbody2D>();
        capsuleCollider = bomberman_t.GetComponent<CapsuleCollider2D>();
    }

    void Update()
    {
      if (!isDead)
      {
        float horizontalMovement = Input.GetAxisRaw("Horizontal");
        float verticalMovement = Input.GetAxisRaw("Vertical");
        moveDirection = new Vector3(horizontalMovement, verticalMovement).normalized;
        this.PlayMovementAnimation(horizontalMovement, verticalMovement);
      }
    }

  private void FixedUpdate()
  {
    if (!isDead)
    {
      bomberman_rgb.MovePosition(bomberman_t.position + moveDirection * moveSpeed * Time.fixedDeltaTime);
    }
    }

  private void PlayMovementAnimation(float moveX, float moveY)
  {
    animator.SetFloat("speed_sideways",Mathf.Abs(moveX));

    if (moveX != 0)
    {
      Vector3 scale = bomberman_t.localScale;
      if (scale.x / moveX < 0)
      {
        scale.x = -bomberman_t.localScale.x;
        bomberman_t.localScale = scale;
      }
    }

    if (moveY > 0)
    {
      animator.SetFloat("speed_up", moveY);
    }
    else if (moveY < 0)
    {
      animator.SetFloat("speed_down", Mathf.Abs(moveY));
    }
    else
    {
      animator.SetFloat("speed_up", 0);
      animator.SetFloat("speed_down", 0);
    }
  }

  public void die()
  {
    capsuleCollider.enabled = false;
    animator.SetTrigger("hasDied");
    animator.SetBool("isDead", true);
    this.isDead = true;
    Invoke("DestroyObject", 2f);

  }

  private void DestroyObject()
  {
    Destroy(gameObject);
    SceneController.instance.NextScene();
  }

  public Vector3Int getCurrentCell()
  {
   return tilemap.WorldToCell(transform.position);
  }

  private void OnTriggerEnter2D(Collider2D collision)
  {
    if (collision.gameObject.tag == "explosion" && !isDead)
    {
      this.die();
    }
    else if (collision.CompareTag("door") && SceneController.instance.getEnemiesLeft() == 0)
    {
      animator.SetTrigger("hasWon");
      Invoke("Win", 2f);
    }
  }

  private void Win()
  {
    SceneController.instance.LoadScene("Win");
  }
}
