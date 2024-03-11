using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Timer : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI timerText;
    private float remainingTime = 90;

    void Update()
    {
        if (remainingTime > 0)
        {
          remainingTime -= Time.deltaTime;
          
        }
        else if (remainingTime < 0)
        {
          remainingTime = 0;
          timerText.color = Color.red;
          FindObjectOfType<BombermanCollider>().die();

        }
        int minutes = Mathf.FloorToInt(remainingTime / 60);
        int seconds = Mathf.FloorToInt(remainingTime % 60);
        timerText.text = string.Format("{00:00}:{1:00}", minutes, seconds);
  }
}
  