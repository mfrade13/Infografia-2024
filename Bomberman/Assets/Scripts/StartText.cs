using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class StartText : MonoBehaviour
{

  private TextMeshProUGUI text;

  private void Start()
  {
    text = GetComponent<TextMeshProUGUI>();
  }
  void Update()
  {
    if (Input.GetKeyDown(KeyCode.Space))
    {
      text.color = Color.white;
      Invoke("StartGame", 1f);
    }
  }

  private void StartGame()
  {
    SceneController.instance.NextScene();
  }
}
