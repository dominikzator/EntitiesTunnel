Shader "MyShaders/Distorted Hologram" {
    Properties {
        [Toggle(ENABLE_HOLOGRAM)] _enableHologram("ENABLE_HOLOGRAM", Float) = 0
        [Toggle(ENABLE_DISTORTION)] _enableDistortion("ENABLE_DISTORTION", Float) = 0
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _StrengthFactor ("Strength Factor", Range(0,1)) = 1
    }
    SubShader {
      Tags{"Queue" = "Transparent"}

        Pass {
            Zwrite On
            ColorMask 0
        }
        
      CGPROGRAM
      
      #pragma surface surf Lambert alpha:fade
      struct Input {
          float3 viewDir;
      };

      struct appdata {
	      	float4 vertex: POSITION;
	      	float3 normal: NORMAL;
	      	float4 texcoord: TEXCOORD0;
            float4 color: COLOR;
      };

      void vert (inout appdata v) {
          v.vertex.xyz += v.color;
      }

      float4 _RimColor;
      float _RimPower;
      float _StrengthFactor;
      float _enableHologram;
      float _enableDistortion;

      float rand(float3 co){
          return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
      }
      
      void surf (Input IN, inout SurfaceOutput o) {
          half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          
          o.Emission = _enableHologram > 0 ? _RimColor.rgb * pow (rim, _RimPower) * 10 : 0;
          o.Alpha = _enableDistortion > 0 ? rand(IN.viewDir) * _StrengthFactor : pow (rim, _RimPower) * _StrengthFactor;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }