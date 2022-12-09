Shader "Custom/Ocean"
{
    Properties
    {
        _Specular ("Specular", Range(0,1)) = 0.5
        _Smoothness ("Smoothness", Range(0,1)) = 0.5

        _WaveSpeed("Wave Speed", Range(0,5)) = 0.5

        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpMap2("Opposite Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf StandardSpecular
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_BumpMap2;
            float3 worldRefl;
            INTERNAL_DATA
        };

        half _Specular;
        half _Smoothness;

        half _WaveSpeed;

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _BumpMap2;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Specular = _Specular;
            o.Smoothness = _Smoothness;

            fixed offsetX = _WaveSpeed * _Time;
            fixed offsetY = _WaveSpeed * _Time;
            fixed2 offsetUV = fixed2(offsetX, offsetY);
            fixed2 normalUV = IN.uv_BumpMap + offsetUV;
            fixed2 mainUV = IN.uv_MainTex + offsetUV;
            float4 normalPixel = tex2D(_BumpMap, normalUV);
            float3 n = UnpackNormal(normalPixel);
            
            fixed offsetX2 = -_WaveSpeed * _Time;
            fixed offsetY2 = -_WaveSpeed * _Time;
            fixed2 offsetUV2 = fixed2(offsetX2, offsetY2);
            fixed2 normalUV2 = IN.uv_BumpMap2 + offsetUV2;
            fixed2 mainUV2 = IN.uv_MainTex + offsetUV2;
            float4 normalPixel2 = tex2D(_BumpMap2, normalUV2);
            float3 n2 = UnpackNormal(normalPixel2);

            o.Normal = (n.xyz + n2.xyz) / 2;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
