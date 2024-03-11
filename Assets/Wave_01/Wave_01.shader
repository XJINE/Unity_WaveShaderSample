Shader "Custom/Wave_01"
{
    Properties
    {
        _MainTex    ("Albedo (RGB)", 2D        ) = "white" {}
        _Color      ("Color",        Color     ) = (1,1,1,1)
        _Glossiness ("Smoothness",   Range(0,1)) = 0.5
        _Metallic   ("Metallic",     Range(0,1)) = 0.0

        _WaveHeight    ("Wave Height",    Float) = 1
        _WaveFrequency ("Wave Frequency", Float) = 1
        _WaveSpeed     ("Wave Speed",     Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows vertex:vert
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };

        sampler2D _MainTex;
        float4    _Color;
        float     _Glossiness;
        float     _Metallic;

        float _WaveHeight;
        float _WaveFrequency;
        float _WaveSpeed;

        void vert(inout appdata_full v, out Input o)
        {
            float wavePower = _WaveHeight * sin(_Time.x * _WaveSpeed + v.vertex.x * _WaveFrequency);

            v.vertex.y = v.vertex.y + wavePower;

            UNITY_INITIALIZE_OUTPUT(Input, o);
        }

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            float4 color = tex2D (_MainTex, i.uv_MainTex) * _Color;

            color.rgb = i.worldNormal;

            o.Albedo     = color.rgb;
            o.Metallic   = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha      = color.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}