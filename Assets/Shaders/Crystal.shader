Shader "Unlit/Crystal"
{
    Properties
    {
        [Toggle(RAINBOW)] _rainbow("RAINBOW", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 tex : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _topColor;
            float4 _bottomColor;
            float _rainbow;

            float rand(float3 co)
            {
                return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
            }

            v2f vert (appdata v)    //vertices in world space, runs on every vertex
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float yPercentage = v.vertex.y / 1.2;
                o.color = float4(rand(v.vertex.x), rand(v.vertex.y), _rainbow > 0 ? rand(v.vertex.z) : 1, 1);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target     //vertices in clipping space, runs on every pixel
            {
                return i.color;
            }

            ENDCG
        }
    }
}
