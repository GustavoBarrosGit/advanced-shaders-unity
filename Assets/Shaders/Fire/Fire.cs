using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class Fire : MonoBehaviour
{
    //Representa os dados de cada partícula de fogo
    public struct Data{
        public Vector3 pos;
        public float vel;
    };
    //número de partículas de fogo a serem criadas
    [Range(1,50)]
    public int amount;
    //representa o material usado para renderizar as partículas de fogo
    public Material material;

    Data[] points;
    ComputeBuffer buffer;

    void Start()
    {
        //um array de Data para armazenar os dados das partículas
        points = new Data[amount];
        //ComputeBuffer para manter os dados das partículas na GPU
        buffer = new ComputeBuffer(amount,16);

        for (int i = 0; i < amount; i++)
        {
            float x = Random.Range(0,360);
            x = Mathf.Cos(x * Mathf.Deg2Rad);

            float z = Random.Range(0,360);
            z = Mathf.Cos(z * Mathf.Deg2Rad);
            //posiçoes e variaveis aleatorias
            points[i].pos = new Vector3(x,0,z);
            points[i].vel = Random.Range(0.5f,1f);
        }
        //array points é copiado para o buffer usando o método SetData
        buffer.SetData(points);
        material.SetBuffer("buffer",buffer);

    }

    private void OnRenderObject() {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points,buffer.count,1);
    }

    private void OnDestroy() {
        buffer.Dispose();
    }
}
