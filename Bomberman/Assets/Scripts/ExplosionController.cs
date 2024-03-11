using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExplosionController : MonoBehaviour
{
  private float countdown = 0.5f;

  void Update()
  {
    countdown -= Time.deltaTime;
    if (countdown <= 0f)
    {
      Destroy(gameObject);
    }
  }
}
