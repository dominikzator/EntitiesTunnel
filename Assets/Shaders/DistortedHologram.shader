Shader "MyShaders/Distorted Hologram" {
    Properties {
        [Toggle(ENABLE_HOLOGRAM)] _enableHologram("ENABLE_HOLOGRAM", Float) = 0
        [Toggle(ENABLE_DISTORTION)] _enableDistortion("ENABLE_DISTORTION", Float) = 0
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _StrengthFactor ("Strength Factor", Range(0,1)) = 1
    }
    SubShader {
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

			v2f vert(appdata v)
			{
				v2f output = (v2f)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, output);

				float3 positionWS = TransformObjectToWorld(v.positionOS);
				output.positionCS = TransformWorldToHClip(positionWS);

				output.color = float4(v.positionOS.xyz, 0);
				
				//output.color = v.uv0;

				return output;
			}

        half4 frag(v2f i) : SV_TARGET
			{
				return i.color;
			}

      CBUFFER_START(UnityPerMaterial)
      float4 _RimColor;
      float _RimPower;
      float _StrengthFactor;
      float _enableHologram;
      float _enableDistortion;
      CBUFFER_END

      float rand(float3 co){
          return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
      }
        
      ENDHLSL
      }
        

    } 
    //Fallback "Diffuse"
  }