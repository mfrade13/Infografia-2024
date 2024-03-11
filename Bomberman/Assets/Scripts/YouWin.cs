using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YouWin : MonoBehaviour
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
