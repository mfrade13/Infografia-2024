using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class GameOverText : MonoBehaviour
{
  void Update()
  {
    if (Input.GetKeyDown(KeyCode.Space))
    {
      Invoke("RestartGame", 1f);
    }
  }

  private void RestartGame()
  {
    SceneController.instance.LoadScene("Menu");
  }
}
