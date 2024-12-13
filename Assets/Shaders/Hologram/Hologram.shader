Shader "Holistic/Hologram" {
    Properties {
      _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader {
      Tags{"Queue" = "Transparent"}

      Pass {
        ZWrite On
        ColorMask 0
      }


      CGPROGRAM
      
      #pragma surface surf Lambert alpha:fade
      struct Input {
          float3 viewDir;
      };

      float4 _RimColor;
      float _RimPower;
      
      void surf (Input IN, inout SurfaceOutput o) {
          half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          o.Emission = _RimColor.rgb * pow (rim, _RimPower) * 10;
          o.Alpha = pow (rim, _RimPower);
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }

  
//Este é um Shader Unity escrito na linguagem ShaderLab. Ele cria um efeito holográfico usando uma técnica de iluminação rim para fazer as bordas do objeto parecerem brilhantes.

//O shader tem duas propriedades:

//_RimColor: uma propriedade de cor que controla a cor da iluminação rim
//_RimPower: uma propriedade de ponto flutuante que controla a intensidade da iluminação rim
//O SubShader tem um único Pass com as configurações ZWrite e ColorMask que desabilitam a escrita no buffer de profundidade e no buffer de cores, respectivamente. Isso permite que os objetos renderizados com este shader apareçam sobre outros objetos e ainda sejam visíveis.

//O bloco CGPROGRAM contém o código do shader escrito na linguagem Cg. A diretiva #pragma surface especifica a função do shader de superfície a ser usada, que neste caso é uma superfície Lambertiana com mesclagem alfa.

//A estrutura Input define os parâmetros de entrada para a função surf, que neste caso inclui a direção da vista.

//A função surf calcula o efeito de iluminação rim, calculando o produto escalar entre a direção da vista e a normal da superfície, e usando isso para determinar quanto a superfície deve emitir luz. A iluminação rim é controlada pelas propriedades _RimColor e _RimPower.

//Finalmente, o shader retorna ao shader Diffuse padrão se o hardware gráfico atual não suportar o shader holográfico.