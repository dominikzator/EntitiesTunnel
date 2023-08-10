//see doc here: https://github.com/ColinLeung-NiloCat/UnityURP-SurfaceShaderSolution

//In user's perspective, this "URP surface shader" .shader file: 
//- must be just one regular .shader file
//- must be as short as possible, user should only need to care & write surface function, no lighting related code should be exposed to user
//- must not contain any lighting related concrete code in this file, user should only need to "edit one line" selecting a reusable lighting function .hlsl.
//- must be always SRP batcher compatible if user write uniforms in CBUFFER correctly
//- must be able to do everything that shader graph can already do
//- must support DepthOnly & ShadowCaster pass with minimum code
//- must support atleast 1 extra custom pass(e.g. outline pass) with minimum code
//- must be "very easy to use & flexible", even if performance cost is higher
//- (future update)this file must be a template file that can be created using unity's editor GUI (right click in project window, Create/Shader/URPSurfaceShader)

//*** Inside this file, user should only care sections with [User editable section] tag, other code can be ignored by user in most cases ***

//__________________________________________[User editable section]__________________________________________\\
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//change this line to any unique path you like, so you can pick this shader in material's shader dropdown menu
Shader "Universal Render Pipeline/SurfaceShaders/HologramURPEntity"
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
{
    Properties
    {
        //__________________________________________[User editable section]__________________________________________\\
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //-Write all per material settings here, just like a regular .shader.
        //-In order to make SRP batcher compatible,
        //make sure to match all uniforms inside CBUFFER_START(UnityPerMaterial) in the next [User editable section]
        
        //below are just some example use case Properties, you can write whatever you want here
        [Header(BaseColor)]
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)
        _Surface("__surface", Float) = 0.0
        _Cutoff("Alpha cutout threshold", Range(0,1)) = 0.5
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }

    HLSLINCLUDE

    //this section are multi_compile keywords set by unity:
    //-Sadly there seems to be no way to hide #pragma from user, 
    // so multi_compile must be copied to every .shader due to shaderlab's design,
    // which makes updating this section in future almost impossible once users already produced lots of .shader files
    //-The good part is exposing multi_compiles which makes editing by user possible, 
    // but it contradict with the goal of surface shader - "hide lighting implementation from user"
    //==================================================================================================================
    //copied URP multi_compile note from Felipe Lira's UniversalPipelineTemplateShader.shader
    //https://gist.github.com/phi-lira/225cd7c5e8545be602dca4eb5ed111ba

    // Universal Render Pipeline keywords
    // When doing custom shaders you most often want to copy and paste these #pragmas,
    // These multi_compile variants are stripped from the build depending on:
    // 1) Settings in the URP Asset assigned in the GraphicsSettings at build time
    // e.g If you disable AdditionalLights in the asset then all _ADDITIONA_LIGHTS variants
    // will be stripped from build
    // 2) Invalid combinations are stripped. e.g variants with _MAIN_LIGHT_SHADOWS_CASCADE
    // but not _MAIN_LIGHT_SHADOWS are invalid and therefore stripped.

    //100% copied from URP PBR shader graph's generated code
    // Pragmas
    #pragma prefer_hlslcc gles
    #pragma exclude_renderers d3d11_9x
    #pragma target 4.5
    #pragma multi_compile_fog

    //100% copied from URP PBR shader graph's generated code
    // Keywords
    #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
    #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

                #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _FORWARD_PLUS
    //==================================================================================================================


    //the core .hlsl of the whole URP surface shader structure, must be included
    #include "../NiloURPSurfaceShader/Core/NiloURPSurfaceShaderInclude.hlsl"


    //__________________________________________[User editable section]__________________________________________\\
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //first, select a lighting function = a .hlsl which contains the concrete body of CalculateSurfaceFinalResultColor(...)
    //you can select any .hlsl you want here, default is NiloPBRLitCelShadeLightingFunction.hlsl, you can always change it
    #include "../NiloURPSurfaceShader/LightingFunctionLibrary//NiloPBRLitCelShadeLightingFunction.hlsl"
    //#include "../LightingFunctionLibrary/NiloPBRLitLightingFunction.hlsl"
    //#include "..........YourOwnLightingFunction.hlsl" //you can always write your own!

    //put your custom #pragma here as usual
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            #pragma shader_feature_local_fragment _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON _ALPHAMODULATE_ON
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local_fragment _OCCLUSIONMAP
            #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
            #pragma shader_feature_local_fragment _SPECULAR_SETUP

    //define texture & sampler as usual
    TEXTURE2D(_BaseMap);
    SAMPLER(sampler_BaseMap);
    TEXTURE2D(_BumpMap);
    SAMPLER(sampler_BumpMap);
    TEXTURE2D(_MetallicR_OcclusionG_SmoothnessA_Tex);
    SAMPLER(sampler_MetallicR_OcclusionG_SmoothnessA_Tex);
    TEXTURE2D(_EmissionMap);
    SAMPLER(sampler_EmissionMap);

    //you must write all your per material uniforms inside this CBUFFER to make SRP batcher compatible
    CBUFFER_START(UnityPerMaterial)
    half4 _BaseColor;
    float _Cutoff;
    CBUFFER_END

    //IMPORTANT: write your surface shader's vertex logic here
    //you ONLY need to re-write things that you want to change, you don't need to fill in all data inside UserGeometryOutputData!
    //All unedited data inside UserGeometryOutputData will always use it's default value, just like shader graph's master node's default values.
    //see struct UserGeometryOutputData inside NiloURPSurfaceShaderInclude.hlsl for all editable data and default values
    //copy the whole UserGeometryOutputData struct here for your reference
    /*
    //100% same as URP PBR shader graph's vertex input
    struct UserGeometryOutputData
    {
        float3 positionOS;
        float3 normalOS;
        float4 tangentOS;
    };
    */
    void UserGeometryDataOutputFunction(Attributes IN, inout UserGeometryOutputData geometryOutputData, bool isExtraCustomPass)
    {
        //geometryOutputData.positionOS += sin(_Time.y * dot(float3(1,1,1),geometryOutputData.positionOS) * 10) * _NoiseStrength * 0.0125; //random sin() vertex anim

        //if(isExtraCustomPass)
        //{
        //    geometryOutputData.positionOS += geometryOutputData.normalOS *_OutlineWidthOS * 0.025; //outline pass needs to enlarge mesh
        //}

        //No need to write all other geometryOutputData.XXX if you don't want to edit them.
        //They will use default value instead
    }

    //MOST IMPORTANT: write your surface shader's fragment logic here
    //you ONLY need re-write things that you want to change, you don't need to fill in all data inside UserSurfaceOutputData!
    //All unedited data inside UserSurfaceOutputData will always use it's default value, just like shader graph's master node's default values.
    //see struct UserSurfaceOutputData inside NiloURPSurfaceShaderInclude.hlsl for all editable data and their default values 
    //copy the whole UserSurfaceOutputData struct here for your reference
    /*
    //100% same as URP PBR shader graph's fragment input
    struct UserSurfaceOutputData
    {
        half3   albedo;             
        half3   normalTS;          
        half3   emission;     
        half    metallic;
        half    smoothness;
        half    occlusion;                
        half    alpha;          
        half    alphaClipThreshold;
    };
    */
    void UserSurfaceOutputDataFunction(Varyings IN, inout UserSurfaceOutputData surfaceData, bool isExtraCustomPass)
    {
        //float2 uv = TRANSFORM_TEX(IN.uv, _BaseMap);
        
        //half4 color = half4(_BaseColor.rgb, 0.3);
        half4 color = _BaseColor;
        surfaceData.emission = color.rgb;
        //surfaceData.albedo = color.rgb;
        surfaceData.alpha = color.a;

        //OutputAlpha(color.a, true);
        
        //surfaceData.emission = _BaseColor.rgb;
        //clip(surfaceData.alpha - _Cutoff);

#if _NORMALMAP
        //surfaceData.normalTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, uv), _BumpScale);
#endif

        //half4 MetallicR_OcclusionG_SmoothnessA = SAMPLE_TEXTURE2D(_MetallicR_OcclusionG_SmoothnessA_Tex, sampler_MetallicR_OcclusionG_SmoothnessA_Tex, uv);
        //surfaceData.occlusion = MetallicR_OcclusionG_SmoothnessA.g; //ao in g
        //surfaceData.metallic = _Metallic * MetallicR_OcclusionG_SmoothnessA.r; //metallic in r
        //surfaceData.smoothness = _Smoothness * MetallicR_OcclusionG_SmoothnessA.a; //smoothness in a

        //surfaceData.emission = _EmissionColor.rgb * _EmissionColor.aaa * SAMPLE_TEXTURE2D(_EmissionMap, sampler_EmissionMap, uv).rgb;

        //isExtraCustomPass is a compile time constant, so writing if() here has 0 performance cost.
        //In this example shader, isExtraCustomPass is true only when executing the custom pass (outline pass)
        //if(isExtraCustomPass)
        //{
        //    //make outline pass darker
        //    surfaceData.albedo = 0;
        //    surfaceData.smoothness = 0;
        //    surfaceData.metallic = 0;
        //    surfaceData.occlusion = 0;
        //}
    }

    //IMPORTANT: write your final fragment color edit logic here
    //usually for gameplay logic's color override or darken, like "loop: lerp to red" for selectable targets / flash white on taking damage / darken dead units...
    //you can replace this function by a #include "Your_own_hlsl.hlsl" call, to share this function between different surface shaders
    void FinalPostProcessFrag(Varyings IN, UserSurfaceOutputData surfaceData, LightingDataHolder lightingData, inout half4 inputColor)
    {
#if _IsSelected
        //inputColor.rgb = lerp(inputColor.rgb,_SelectedLerpColor.rgb, _SelectedLerpColor.a * (sin(_Time.y * 5) * 0.5 + 0.5));
#endif

        //half4 col = half4(lightingData.viewDirectionWS.xyz,1);

        //half4 color = _BaseColor;
        //surfaceData.albedo = color.rgb;
        //surfaceData.alpha = color.a;
        
        //inputColor = col;
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ENDHLSL

    SubShader
    {
        Tags 
        { 
            "RenderPipeline"="UniversalRenderPipeline"

            //__________________________________________[User editable section]__________________________________________\\
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //You can edit per SubShader tags here as usual
            //doc: https://docs.unity3d.com/Manual/SL-SubShaderTags.html
            
            "Queue" = "Transparent"
            "RenderType" = "Transparent"

            "DisableBatching" = "False"
            "ForceNoShadowCasting" = "False"
            "IgnoreProjector" = "True"
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        }

        //UniversalForward pass
        Pass
        {
            Name "Universal Forward"
            Tags { "LightMode"="UniversalForward" }

            //__________________________________________[User editable section]__________________________________________\\
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //You can edit per Pass Render State here as usual
            //doc: https://docs.unity3d.com/Manual/SL-Pass.html
            
            Cull Back
            ZTest LEqual
            ZWrite On
            Offset 0,0
            //Blend One Zero
            ColorMask RGBA

            //stencil also 
            //doc: https://docs.unity3d.com/Manual/SL-Stencil.html
            Stencil
            {
                //...
            }
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

            HLSLPROGRAM
            #pragma vertex vertUniversalForward
            #pragma fragment fragUniversalForward
            ENDHLSL
        }

 
        //__________________________________________[User editable section]__________________________________________\\
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //User can insert 1 extra custom passes here.
        //For example, an outline pass this time
        Pass
        {
            //no LightMode is needed for extra custom pass
            Cull front
            HLSLPROGRAM
            #pragma vertex vertExtraCustomPass
            #pragma fragment fragExtraCustomPass
            ENDHLSL
        }
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
          
        //ShadowCaster pass, for rendering this shader into URP's shadowmap renderTextures
        //User should not need to edit this pass in most cases
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }
            ColorMask 0 //optimization: ShadowCaster pass don't care fragment shader output value, disable color write to reduce bandwidth usage

            HLSLPROGRAM

            #pragma vertex vertShadowCaster
            #pragma fragment fragDoAlphaClipOnlyAndEarlyExit

            ENDHLSL
        }

        //DepthOnly pass, for rendering this shader into URP's _CameraDepthTexture
        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode"="DepthOnly" }
            ColorMask 0 //optimization: DepthOnly pass don't care fragment shader output value, disable color write to reduce bandwidth usage

            HLSLPROGRAM

            //__________________________________________[User editable section]__________________________________________\\
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //not using vertUniversalForward function due to outline pass edited positionOS by bool isExtraCustomPass in UserGeometryDataOutputFunction(...)
            //#pragma vertex vertUniversalForward

            //we use this instead, this will inlcude positionOS change in UserGeometryDataOutputFunction, include isExtraCustomPass(outlinePass)'s vertex logic.
            //we only do this due to the fact that this shader's extra pass is an opaque outline pass
            //where opaque outline should affacet depth write also
            #pragma vertex vertExtraCustomPass
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

            #pragma fragment fragDoAlphaClipOnlyAndEarlyExit

            ENDHLSL
        }
    }
}