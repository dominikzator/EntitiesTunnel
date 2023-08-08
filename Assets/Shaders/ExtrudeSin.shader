Shader "MyShaders/ExtrudeSin" {
	Properties {
	    [Toggle(ENABLE_HIGHLIGHT_COLORS)] _enableHighlightColors("ENABLE_HIGHLIGHT_COLORS", Float) = 0
	    _ExtrudeColor("Extrude Color", Color) = (1,1,1,1)
	    _OtherColor("Other Color", Color) = (1,1,1,1)
    	[Toggle(ENABLE_SINTIME_BEHAVIOUR)] _enableSinTimeBehaviour("ENABLE_SINTIME_BEHAVIOUR", Float) = 0
	    _MainTex ("Texture", 2D) = "white" {}
	    _Amount ("Extrude", Range(-1,1)) = 0.01
		_Speed("Speed", Range(1,1000)) = 10
		_xBoundary("X Boundary", Range(-1,1)) = 0
		_yBoundary("Y Boundary", Range(0,1.4)) = 0
    	
		_xMagnitude("X Magnitude", Range(0,2)) = 0
		_yMagnitude("Y Magnitude", Range(0,1.4)) = 0
    }
    SubShader {
	    CGPROGRAM
	    #pragma surface surf Lambert vertex:vert
	      
	    struct Input {
	    	float2 uv_MainTex;
	    	float3 vertColor;
	    };

	    struct appdata {
	      	float4 vertex: POSITION;
	      	float4 vertex2: POSITION;
	      	float3 normal: NORMAL;
	      	float4 texcoord: TEXCOORD0;
	    };

	    float4 _ExtrudeColor;
	    float4 _OtherColor;
	    float _Amount;
	    float _Speed;
	    float _xBoundary;
	    float _yBoundary;
	    float _xMagnitude;
	    float _yMagnitude;
	    float _enableSinTimeBehaviour;
	    float _enableHighlightColors;
      
	    void vert (inout appdata v, out Input o) {
	    	UNITY_INITIALIZE_OUTPUT(Input,o);
	      	const float PI = 3.14159265;
	        float t = _Time.x * _Speed;
	      	float sinValue = sin(t/4.0*PI) + sin(t/4.0*PI + 2*PI/4);
	      	sinValue = (_enableSinTimeBehaviour > 0) ? clamp(sinValue, 0, 1) : 1;
	    	
	      	if(v.vertex.y > _yBoundary - _yMagnitude && v.vertex.y < _yBoundary + _yMagnitude
	      		&& v.vertex.x > _xBoundary - _xMagnitude && v.vertex.x < _xBoundary + _xMagnitude)
	      	{
	      		v.vertex.xyz += v.normal * _Amount * sinValue;
	      		o.vertColor = _ExtrudeColor;
	      	}
	        else
	        {
	        	o.vertColor = _OtherColor;
	        }
	    }

	    sampler2D _MainTex;
	    void surf (Input IN, inout SurfaceOutput o) {
	    	if(_enableHighlightColors)
	    	{
	    		o.Albedo = IN.vertColor;
	    	}
	        else
	        {
	        	o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
	        }
	    }

    	ENDCG
    } 
    Fallback "Diffuse"
  }