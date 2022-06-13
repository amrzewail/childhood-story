Shader "Converted/Custom Lit Normalized"
{
    Properties
    {
        [NoScaleOffset]_BaseMap("BaseMap", 2D) = "white" {}
        Color_cd842a3ee0214cdd96473950bdbae13c("Base Color", Color) = (1, 1, 1, 1)
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
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
        #define VARYINGS_NEED_COLOR
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
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp3.xyzw =  input.color;
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
            output.color = input.interp3.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = 0;
            surface.Occlusion = 1;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
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
        #define VARYINGS_NEED_COLOR
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
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp3.xyzw =  input.color;
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
            output.color = input.interp3.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = 0;
            surface.Occlusion = 1;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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
        #define VARYINGS_NEED_NORMAL_WS
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            // GraphFunctions: <None>

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
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            // GraphFunctions: <None>

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
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
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
            output.interp1.xyzw =  input.tangentWS;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            // GraphFunctions: <None>

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
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
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
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp2.xyzw =  input.color;
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
            output.color = input.interp2.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
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
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp2.xyzw =  input.color;
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
            output.color = input.interp2.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
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
        #define VARYINGS_NEED_COLOR
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
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp3.xyzw =  input.color;
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
            output.color = input.interp3.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = 0;
            surface.Occlusion = 1;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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
        #define VARYINGS_NEED_NORMAL_WS
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            // GraphFunctions: <None>

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
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            // GraphFunctions: <None>

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
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
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
            output.interp1.xyzw =  input.tangentWS;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            // GraphFunctions: <None>

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
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
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
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp2.xyzw =  input.color;
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
            output.color = input.interp2.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
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
            float4 color : COLOR;
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
            float4 color;
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
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
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
            output.interp2.xyzw =  input.color;
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
            output.color = input.interp2.xyzw;
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
        float4 Color_cd842a3ee0214cdd96473950bdbae13c;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

            // Graph Functions
            
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01
        {
            float3 WorldSpaceNormal;
            float3 WorldSpacePosition;
            float4 VertexColor;
        };

        void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 IN, out float4 OutVector4_1)
        {
            float4 _Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0 = Vector4_a444492d8c8444bda91d57dc2302a74e;
            UnityTexture2D _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0 = Texture2D_7271fc85ae2344cfabe11a3c6c356949;
            float _Split_6e0beeb35c1c457cad33b78577ff4165_R_1 = IN.WorldSpacePosition[0];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_G_2 = IN.WorldSpacePosition[1];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_B_3 = IN.WorldSpacePosition[2];
            float _Split_6e0beeb35c1c457cad33b78577ff4165_A_4 = 0;
            float _Split_94185fa11907402d9832cfdba084c033_R_1 = IN.WorldSpaceNormal[0];
            float _Split_94185fa11907402d9832cfdba084c033_G_2 = IN.WorldSpaceNormal[1];
            float _Split_94185fa11907402d9832cfdba084c033_B_3 = IN.WorldSpaceNormal[2];
            float _Split_94185fa11907402d9832cfdba084c033_A_4 = 0;
            float _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_R_1, _Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1);
            float _Comparison_970753147cb64a838ee6611101d98881_Out_2;
            Unity_Comparison_Greater_float(_Absolute_d5f45ccb78504d81850bc7fa8018d69d_Out_1, 0.5, _Comparison_970753147cb64a838ee6611101d98881_Out_2);
            float _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3;
            Unity_Branch_float(_Comparison_970753147cb64a838ee6611101d98881_Out_2, 1, 0, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3);
            float _Multiply_893a48c114c24e20866cf870888c8a04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
            float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
            float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
            Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
            float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
            Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
            float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
            float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
            Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
            float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
            Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
            float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
            Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
            float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
            Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
            float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
            float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
            Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
            float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
            float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
            float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
            Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
            float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
            Unity_Multiply_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
            float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
            Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
            float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0);
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
            float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
            float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
            Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
            float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
            Unity_Multiply_float(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
            OutVector4_1 = _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
        }

        void Unity_Absolute_float3(float3 In, out float3 Out)
        {
            Out = abs(In);
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
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
            UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01 _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
            _GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
            float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
            SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
            Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
            Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
            float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
            float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
            float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
            float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
            Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
            Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
            Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
            Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            Unity_Multiply_float(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
            #endif
            surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
            surface.Alpha = 0.5;
            surface.AlphaClipThreshold = 0.5;
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
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
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