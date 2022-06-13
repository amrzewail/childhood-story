Shader "Converted/Custom Lit"
{
    Properties
    {
        [NoScaleOffset]_BaseMap("BaseMap", 2D) = "white" {}
        Vector2_8ee5a556b4d046b3a8c9adce321b3395("Tiling", Vector) = (1, 1, 0, 0)
        Vector2_1("Offset", Vector) = (0, 0, 0, 0)
        [NoScaleOffset]Texture2D_77affed0828247b3b6ea3b11fa548e9f("Normal Map", 2D) = "white" {}
        Vector2_b80657cf80274ccd82ed09e1fe86c9fa("Normal Tiling", Vector) = (1, 1, 0, 0)
        Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1("Normal Offset", Vector) = (1, 1, 0, 0)
        Vector1_0a00614199e54d41935eebc6f3c17f6a("Ambient Occlusion", Range(0, 1)) = 1
        Vector1_1372c971da0e4d2d84dea947b8369957("Alpha Clipping", Range(0, 1)) = 0.5
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 viewDirectionWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 lightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 fogFactorAndVertexLight;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp4 : TEXCOORD4;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 interp5 : TEXCOORD5;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp6 : TEXCOORD6;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp7 : TEXCOORD7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp8 : TEXCOORD8;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e7c0e839d87e422288fd4b4782ead1f5_Out_0 = Vector1_0a00614199e54d41935eebc6f3c17f6a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = 0;
            surface.Occlusion = _Property_e7c0e839d87e422288fd4b4782ead1f5_Out_0;
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "CustomForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 viewDirectionWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 lightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 fogFactorAndVertexLight;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp4 : TEXCOORD4;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 interp5 : TEXCOORD5;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp6 : TEXCOORD6;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp7 : TEXCOORD7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp8 : TEXCOORD8;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e7c0e839d87e422288fd4b4782ead1f5_Out_0 = Vector1_0a00614199e54d41935eebc6f3c17f6a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = 0;
            surface.Occlusion = _Property_e7c0e839d87e422288fd4b4782ead1f5_Out_0;
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 viewDirectionWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 lightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 fogFactorAndVertexLight;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp4 : TEXCOORD4;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 interp5 : TEXCOORD5;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp6 : TEXCOORD6;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp7 : TEXCOORD7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp8 : TEXCOORD8;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e7c0e839d87e422288fd4b4782ead1f5_Out_0 = Vector1_0a00614199e54d41935eebc6f3c17f6a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = 0;
            surface.Occlusion = _Property_e7c0e839d87e422288fd4b4782ead1f5_Out_0;
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "CustomForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _SPECULARHIGHLIGHTS_OFF

        #if defined(_SPECULARHIGHLIGHTS_OFF)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _BaseMap_TexelSize;
        float2 Vector2_8ee5a556b4d046b3a8c9adce321b3395;
        float2 Vector2_1;
        float4 Texture2D_77affed0828247b3b6ea3b11fa548e9f_TexelSize;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa;
        float2 Vector2_b80657cf80274ccd82ed09e1fe86c9fa_1;
        float Vector1_0a00614199e54d41935eebc6f3c17f6a;
        float Vector1_1372c971da0e4d2d84dea947b8369957;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        TEXTURE2D(Texture2D_77affed0828247b3b6ea3b11fa548e9f);
        SAMPLER(samplerTexture2D_77affed0828247b3b6ea3b11fa548e9f);
        float Vector1_be5bc0843a7344939ad930e4323df76b;
        float Vector1_7906282fd6eb41d793a5f43f811ad931;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_8720c32124f9425eb4e15c17ca169437_Out_0 = Vector2_8ee5a556b4d046b3a8c9adce321b3395;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Property_812b978832b94c6f9aa89b38263144f8_Out_0 = Vector2_1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_8720c32124f9425eb4e15c17ca169437_Out_0, _Property_812b978832b94c6f9aa89b38263144f8_Out_0, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.tex, _Property_c59b1fa9d912459fbae315c0deaa1bfe_Out_0.samplerstate, _TilingAndOffset_1ce6fab79a6742f6a3ce66bcb9f901ea_Out_3);
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_R_4 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.r;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_G_5 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.g;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_B_6 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.b;
            float _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7 = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0 = Vector1_1372c971da0e4d2d84dea947b8369957;
            #endif
            surface.BaseColor = (_SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_RGBA_0.xyz);
            surface.Alpha = _SampleTexture2D_6ff91a1cdc4e491b9255e26a1c819ca5_A_7;
            surface.AlphaClipThreshold = _Property_cfe7611ff9b546be97a4d9ce4bb78d1f_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    CustomEditor "ShaderGraph.PBRMasterGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}