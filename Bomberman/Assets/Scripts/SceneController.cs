using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneController : MonoBehaviour
{
  public static SceneController instance;
  private int enemiesLeft;
  private void Awake()
  {
    if (instance == null)
    {
      instance = this;
      enemiesLeft = 3;
      DontDestroyOnLoad(gameObject);
    }
    else
    {
      Destroy(gameObject);
    }

  }
  public int getEnemiesLeft()
  {
    return enemiesLeft;
  }

  public void resetEnemiesLeft()
  {
    this.enemiesLeft = 3;
  }

  public void killEnemy()
  {
    this.enemiesLeft--;
  }

  public void NextScene()
  {
    SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().buildIndex + 1);
  }

  public void LoadScene(string sceneName) 
  {
    if (sceneName.Equals("Menu"))
    {
      this.resetEnemiesLeft();
    }
    SceneManager.LoadSceneAsync(sceneName);
  }
}
