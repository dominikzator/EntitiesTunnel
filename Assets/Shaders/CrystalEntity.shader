Shader "Entities/Crystal"
{
	Properties
	{
		[Toggle(RAINBOW)] _rainbow("RAINBOW", Float) = 0
	}
	SubShader
	{
		Tags
		{
			//"RenderPipeline"="UniversalPipeline"
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}
		Pass
		{
			Name "Pass"

			HLSLPROGRAM

			#pragma target 4.5
			#pragma multi_compile_instancing
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"

			struct appdata
			{
				float3 positionOS : POSITION;
				float4 uv0 : TEXCOORD0;
				#if UNITY_ANY_INSTANCING_ENABLED
				uint instanceID : INSTANCEID_SEMANTIC;
				#endif
			};

			struct v2f
			{
				float4 positionCS : SV_POSITION;
				float4 color : COLOR;
				#if UNITY_ANY_INSTANCING_ENABLED
				uint instanceID : CUSTOM_INSTANCE_ID;
				#endif
			};

			CBUFFER_START(UnityPerMaterial)
			float _rainbow;
			CBUFFER_END
			
			float rand(float3 co)
            {
                return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
            }
			
			v2f vert(appdata v)
			{
				v2f output = (v2f)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, output);

				float3 positionWS = TransformObjectToWorld(v.positionOS);
				output.positionCS = TransformWorldToHClip(positionWS);
				output.color = float4(rand(v.positionOS.x), rand(v.positionOS.y), _rainbow > 0 ? rand(v.positionOS.z) : 1, 1);

				return output;
			}

			half4 frag(v2f i) : SV_TARGET
			{
				return i.color;
			}

			ENDHLSL
		}
	}
}

