Shader "Custom/Window"
{
    Properties
    {
        _ClearColor("Clear Color", Color) = (1,1,1,1)
        _FogColor("Fog Color", Color) = (1,1,1,1)
        _BlurRadius("Blur Radius", float) = 3
        _MaxAge("Max Age", float) = 3
        _MaskTex("Mask Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }

        GrabPass
        {
            "_BGTex"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "blur.cginc"

            uniform float4 _ClearColor;
            uniform float4 _FogColor;
            uniform float _BlurRadius;
            uniform float _MaxAge;
            uniform sampler2D _MaskTex;

            uniform sampler2D _BGTex;
            uniform float4 _BGTex_TexelSize;

            uniform sampler2D _PlayerMap;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 texCoord : TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float2 texCoord : TEXCOORD0;
                float4 grabPos : TEXCOORD1;
            };

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.grabPos = ComputeGrabScreenPos(output.pos);
                output.texCoord = input.texCoord;
                return output;
            }

            float4 frag(vertexOutput input) : COLOR
            {
                float4 bg = tex2Dproj(_BGTex, input.grabPos);

                float timeDrawn = tex2D(_PlayerMap, input.texCoord.xy).r;
                float age = clamp(_Time.y - timeDrawn, 0.0001, _Time.y);
                float percentMaxAge = saturate(age / _MaxAge);

                float mask = tex2D(_MaskTex, input.texCoord.xy).r;
                float blurRadius = _BlurRadius * percentMaxAge * mask;
                float4 color = (1 - percentMaxAge * mask) * _ClearColor + percentMaxAge * _FogColor;

                float4 blurX = gaussianBlur(float2(1,0), input.grabPos, _BGTex_TexelSize.z, _BGTex, blurRadius);
                float4 blurY = gaussianBlur(float2(0,1), input.grabPos, _BGTex_TexelSize.w, _BGTex, blurRadius);
                return (blurX + blurY) * color;
            }

            ENDCG
        }
    }
}
