﻿Shader "Unlit/RayMarchingShader"
{
    Properties
    {
        _Color ("Color",Color) = (1,1,1,1)
        _LightColor ("Color",Color) = (1,1,1,1)
        _Center ("Center",Vector) = (0,0,0,0)
        _Radius ("Radius",Range(0.1,25)) = 1
        _Diffuse ("Diffuse",Range(0,1)) = 1
        _Specular ("Specular",Range(0,1)) = 1
        _Displacement ("Displacement",Range(0,20)) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 _Color;
            float4 _Center;
            float _Radius;
            float4 _LightColor;
            float _Diffuse;
            float _Specular;
            float _Displacement;

            #include "UnityCG.cginc"
            #include "RayMarching.cginc"
            #include "Structs 1.cginc"
            #include "Light.cginc"

            v2f vert (appdata v)
            {
                v2f o;
                o.wPos = mul(unity_ObjectToWorld,v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                float3 pos;
                float4 col = float4(0,0,0,0);
                float3 rayOrigin = _WorldSpaceCameraPos;
                float3 rayDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                int rm = raymarching(rayOrigin,rayDirection,pos);
                if(rm==1)
                {
                    float3 normal = calculate_normal(pos);
                    col = _Color + _LightColor * light_diffuse(normal) * _Diffuse + _LightColor * light_specular(normal,i.wPos) * _Specular;
                }
                return col;
            }
            ENDCG
        }
    }
}
