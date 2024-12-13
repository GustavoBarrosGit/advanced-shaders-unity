using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FocusOnPlayer : MonoBehaviour
{
    public Camera cam;
    public Renderer destinationRenderer;
    public int TextureSize;
    public int Radius;
    public float cooldownPeriod = 1f;
    public GameObject spaceship;
    public Texture2D maskTexture;

    private Texture2D texture;
    private float lastUpdateTime = -1f;

    void Start()
    {
        texture = new Texture2D(TextureSize, TextureSize, TextureFormat.RFloat, false, true);
        destinationRenderer.material.SetTexture("_MaskTex", maskTexture);
        for (int i = 0; i < texture.height; i++)
        {
            for (int j = 0; j < texture.width; j++)
            {
                texture.SetPixel(i, j, Color.clear);
            }
        }
        texture.Apply();
        destinationRenderer.material.SetTexture("_PlayerMap", texture);
    }

    void Update()
    {
        if (Time.time < lastUpdateTime + cooldownPeriod)
        {
            return;
        }

        Ray ray = cam.ScreenPointToRay(cam.WorldToScreenPoint(spaceship.transform.position));
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 100))
        {
            Color color = new Color(Time.timeSinceLevelLoad, 0, 0, 1);

            int x = (int)(hit.textureCoord.x * texture.width);
            int y = (int)(hit.textureCoord.y * texture.height);

            texture.SetPixel(x, y, color);

            for (int i = Mathf.Max(0, x - Radius); i <= Mathf.Min(texture.width - 1, x + Radius); i++)
            {
                for (int j = Mathf.Max(0, y - Radius); j <= Mathf.Min(texture.height - 1, y + Radius); j++)
                {
                    float dist = Vector2.Distance(new Vector2(i, j), new Vector2(x, y));
                    if (dist <= Radius)
                        texture.SetPixel(i, j, color);
                }
            }

            texture.Apply();
            destinationRenderer.material.SetTexture("_PlayerMap", texture);
            lastUpdateTime = Time.time;
        }
    }
}
