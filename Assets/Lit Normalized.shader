Shader "Converted/Lit Normalized"
{
Properties
{
[NoScaleOffset]_BaseMap("BaseMap", 2D) = "white" {}
Color_cd842a3ee0214cdd96473950bdbae13c("Base Color", Color) = (1, 1, 1, 1)
[HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
[HideInInspector]_QueueControl("_QueueControl", Float) = -1
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
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="UniversalLitSubTarget"
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
#pragma instancing_options renderinglayer
#pragma multi_compile _ DOTS_INSTANCING_ON
#pragma vertex vert
#pragma fragment frag

// DotsInstancingOptions: <None>
// HybridV1InjectedBuiltinProperties: <None>

// Keywords
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _SHADOWS_SOFT
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _LIGHT_LAYERS
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile_fragment _ _LIGHT_COOKIES
#pragma multi_compile _ _CLUSTERED_RENDERING
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_VIEWDIRECTION_WS
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 color;
 float3 viewDirectionWS;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 TangentSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
 float4 interp3 : INTERP3;
 float3 interp4 : INTERP4;
 float2 interp5 : INTERP5;
 float2 interp6 : INTERP6;
 float3 interp7 : INTERP7;
 float4 interp8 : INTERP8;
 float4 interp9 : INTERP9;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.interp0.xyz =  input.positionWS;
output.interp1.xyz =  input.normalWS;
output.interp2.xyzw =  input.tangentWS;
output.interp3.xyzw =  input.color;
output.interp4.xyz =  input.viewDirectionWS;
#if defined(LIGHTMAP_ON)
output.interp5.xy =  input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.interp6.xy =  input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.interp7.xyz =  input.sh;
#endif
output.interp8.xyzw =  input.fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.interp9.xyzw =  input.shadowCoord;
#endif
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
output.staticLightmapUV = input.interp5.xy;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.interp6.xy;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.interp7.xyz;
#endif
output.fogFactorAndVertexLight = input.interp8.xyzw;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.interp9.xyzw;
#endif
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "CustomForwardPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
#pragma instancing_options renderinglayer
#pragma multi_compile _ DOTS_INSTANCING_ON
#pragma vertex vert
#pragma fragment frag

// DotsInstancingOptions: <None>
// HybridV1InjectedBuiltinProperties: <None>

// Keywords
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _SHADOWS_SOFT
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma multi_compile_fragment _ _LIGHT_LAYERS
#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
#pragma multi_compile_fragment _ DEBUG_DISPLAY
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_VIEWDIRECTION_WS
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_GBUFFER
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 color;
 float3 viewDirectionWS;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 TangentSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
 float4 interp3 : INTERP3;
 float3 interp4 : INTERP4;
 float2 interp5 : INTERP5;
 float2 interp6 : INTERP6;
 float3 interp7 : INTERP7;
 float4 interp8 : INTERP8;
 float4 interp9 : INTERP9;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.interp0.xyz =  input.positionWS;
output.interp1.xyz =  input.normalWS;
output.interp2.xyzw =  input.tangentWS;
output.interp3.xyzw =  input.color;
output.interp4.xyz =  input.viewDirectionWS;
#if defined(LIGHTMAP_ON)
output.interp5.xy =  input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.interp6.xy =  input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.interp7.xyz =  input.sh;
#endif
output.interp8.xyzw =  input.fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.interp9.xyzw =  input.shadowCoord;
#endif
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
output.staticLightmapUV = input.interp5.xy;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.interp6.xy;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.interp7.xyz;
#endif
output.fogFactorAndVertexLight = input.interp8.xyzw;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.interp9.xyzw;
#endif
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define VARYINGS_NEED_NORMAL_WS
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALS
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 tangentWS;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float4 interp1 : INTERP1;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
#pragma shader_feature _ EDITOR_VISUALIZATION
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_META
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
 float4 interp3 : INTERP3;
 float4 interp4 : INTERP4;
 float4 interp5 : INTERP5;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.interp0.xyz =  input.positionWS;
output.interp1.xyz =  input.normalWS;
output.interp2.xyzw =  input.texCoord0;
output.interp3.xyzw =  input.texCoord1;
output.interp4.xyzw =  input.texCoord2;
output.interp5.xyzw =  input.color;
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
output.texCoord0 = input.interp2.xyzw;
output.texCoord1 = input.interp3.xyzw;
output.texCoord2 = input.interp4.xyzw;
output.color = input.interp5.xyzw;
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
surface.Emission = float3(0, 0, 0);
surface.Alpha = 0.5;
surface.AlphaClipThreshold = 0.5;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "SceneSelectionPass"
    Tags
    {
        "LightMode" = "SceneSelectionPass"
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
// PassKeywords: <None>
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENESELECTIONPASS 1
#define ALPHA_CLIP_THRESHOLD 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ScenePickingPass"
    Tags
    {
        "LightMode" = "Picking"
    }

// Render State
Cull Back

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENEPICKINGPASS 1
#define ALPHA_CLIP_THRESHOLD 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_2D
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
surface.Alpha = 0.5;
surface.AlphaClipThreshold = 0.5;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="UniversalLitSubTarget"
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
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// DotsInstancingOptions: <None>
// HybridV1InjectedBuiltinProperties: <None>

// Keywords
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _SHADOWS_SOFT
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _LIGHT_LAYERS
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile_fragment _ _LIGHT_COOKIES
#pragma multi_compile _ _CLUSTERED_RENDERING
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_VIEWDIRECTION_WS
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 color;
 float3 viewDirectionWS;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 TangentSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
 float4 interp3 : INTERP3;
 float3 interp4 : INTERP4;
 float2 interp5 : INTERP5;
 float2 interp6 : INTERP6;
 float3 interp7 : INTERP7;
 float4 interp8 : INTERP8;
 float4 interp9 : INTERP9;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.interp0.xyz =  input.positionWS;
output.interp1.xyz =  input.normalWS;
output.interp2.xyzw =  input.tangentWS;
output.interp3.xyzw =  input.color;
output.interp4.xyz =  input.viewDirectionWS;
#if defined(LIGHTMAP_ON)
output.interp5.xy =  input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.interp6.xy =  input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.interp7.xyz =  input.sh;
#endif
output.interp8.xyzw =  input.fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.interp9.xyzw =  input.shadowCoord;
#endif
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
output.staticLightmapUV = input.interp5.xy;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.interp6.xy;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.interp7.xyz;
#endif
output.fogFactorAndVertexLight = input.interp8.xyzw;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.interp9.xyzw;
#endif
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "CustomForwardPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define VARYINGS_NEED_NORMAL_WS
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD1
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALS
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv1 : TEXCOORD1;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 tangentWS;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float4 interp1 : INTERP1;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
#pragma shader_feature _ EDITOR_VISUALIZATION
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_META
#define _FOG_FRAGMENT 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
 float4 interp3 : INTERP3;
 float4 interp4 : INTERP4;
 float4 interp5 : INTERP5;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.interp0.xyz =  input.positionWS;
output.interp1.xyz =  input.normalWS;
output.interp2.xyzw =  input.texCoord0;
output.interp3.xyzw =  input.texCoord1;
output.interp4.xyzw =  input.texCoord2;
output.interp5.xyzw =  input.color;
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
output.texCoord0 = input.interp2.xyzw;
output.texCoord1 = input.interp3.xyzw;
output.texCoord2 = input.interp4.xyzw;
output.color = input.interp5.xyzw;
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
surface.Emission = float3(0, 0, 0);
surface.Alpha = 0.5;
surface.AlphaClipThreshold = 0.5;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "SceneSelectionPass"
    Tags
    {
        "LightMode" = "SceneSelectionPass"
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
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// DotsInstancingOptions: <None>
// HybridV1InjectedBuiltinProperties: <None>

// Keywords
// PassKeywords: <None>
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENESELECTIONPASS 1
#define ALPHA_CLIP_THRESHOLD 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ScenePickingPass"
    Tags
    {
        "LightMode" = "Picking"
    }

// Render State
Cull Back

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENEPICKINGPASS 1
#define ALPHA_CLIP_THRESHOLD 1
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

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
// GraphKeywords: <None>

// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_2D
#define _ALPHATEST_ON 1
/* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 WorldSpacePosition;
 float4 VertexColor;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float3 interp0 : INTERP0;
 float3 interp1 : INTERP1;
 float4 interp2 : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
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

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

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

void Unity_Multiply_float_float(float A, float B, out float Out)
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

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

struct Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float
{
float3 WorldSpaceNormal;
float3 WorldSpacePosition;
float4 VertexColor;
};

void SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(UnityTexture2D Texture2D_7271fc85ae2344cfabe11a3c6c356949, float4 Vector4_a444492d8c8444bda91d57dc2302a74e, Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float IN, out float4 OutVector4_1)
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
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_893a48c114c24e20866cf870888c8a04_Out_2);
float _Absolute_0b7729f92cbb432585664353e67160b7_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_B_3, _Absolute_0b7729f92cbb432585664353e67160b7_Out_1);
float _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2;
Unity_Comparison_Greater_float(_Absolute_0b7729f92cbb432585664353e67160b7_Out_1, 0.5, _Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2);
float _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3;
Unity_Branch_float(_Comparison_cbb35f9f19b846f5b10b288aed11e498_Out_2, 1, 0, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3);
float _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2);
float _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2;
Unity_Add_float(_Multiply_893a48c114c24e20866cf870888c8a04_Out_2, _Multiply_fc3c5df3f9ec4670b8455f13ac101ac2_Out_2, _Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2);
float _Absolute_29eb4d41383e41279513377bc4319436_Out_1;
Unity_Absolute_float(_Split_94185fa11907402d9832cfdba084c033_G_2, _Absolute_29eb4d41383e41279513377bc4319436_Out_1);
float _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2;
Unity_Comparison_Greater_float(_Absolute_29eb4d41383e41279513377bc4319436_Out_1, 0.5, _Comparison_46dd713e51ac41a886e181bbd613c790_Out_2);
float _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3;
Unity_Branch_float(_Comparison_46dd713e51ac41a886e181bbd613c790_Out_2, 1, 0, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3);
float _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_R_1, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2);
float _Add_59706a78b5124986834fe64c9a03a0c7_Out_2;
Unity_Add_float(_Add_cf720ca1ebd44dc7a9dab7b2b101f408_Out_2, _Multiply_9c1dfc194ed84268ab2bf8996f73651f_Out_2, _Add_59706a78b5124986834fe64c9a03a0c7_Out_2);
float _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_be4c61a3d11341f79a5e2e90db0b428f_Out_3, _Multiply_be00511be1854ea390f7bb8a5e823406_Out_2);
float _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_G_2, _Branch_eacbc9f8919c427eb7bf1ac55540fa9d_Out_3, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2);
float _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2;
Unity_Add_float(_Multiply_be00511be1854ea390f7bb8a5e823406_Out_2, _Multiply_b4b2fd19f57d4044b0157784c0ea8b04_Out_2, _Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2);
float _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2;
Unity_Multiply_float_float(_Split_6e0beeb35c1c457cad33b78577ff4165_B_3, _Branch_757a5779e5b347e99ffd155c6ff7757d_Out_3, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2);
float _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2;
Unity_Add_float(_Add_cacdea6f53654d2f800bccf7c5b3322f_Out_2, _Multiply_7ec0382ff6d347ac8b2d07f7da475ace_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float2 _Vector2_78f47a7fd291415a8ba411b062eda129_Out_0 = float2(_Add_59706a78b5124986834fe64c9a03a0c7_Out_2, _Add_6b557ef6bc994aa79f0eff056ac89019_Out_2);
float4 _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0 = SAMPLE_TEXTURE2D(_Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.tex, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.samplerstate, _Property_68c282163d764f67b8b16ec0c15a2bc4_Out_0.GetTransformedUV(_Vector2_78f47a7fd291415a8ba411b062eda129_Out_0));
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_R_4 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.r;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_G_5 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.g;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_B_6 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.b;
float _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_A_7 = _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0.a;
float4 _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3;
Unity_Lerp_float4(IN.VertexColor, _SampleTexture2D_f81f00ea4e9047ccb222cb8a33e61024_RGBA_0, float4(0.5, 0.5, 0.5, 0.5), _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3);
float4 _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2;
Unity_Multiply_float4_float4(_Property_39119bea58a4446b98a8dbf46fd3d97b_Out_0, _Lerp_17711dcfa4394e3dbce961abbb05b723_Out_3, _Multiply_3642d8bce83e45f48d0fbfebc90a56a3_Out_2);
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

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

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

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

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
UnityTexture2D _Property_afcbc0150b62462690fcce1af6cd55da_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMap);
float4 _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0 = Color_cd842a3ee0214cdd96473950bdbae13c;
Bindings_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float _GridSubshader_78b9424da3c44060bf308756fb6ccedd;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpaceNormal = IN.WorldSpaceNormal;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.WorldSpacePosition = IN.WorldSpacePosition;
_GridSubshader_78b9424da3c44060bf308756fb6ccedd.VertexColor = IN.VertexColor;
float4 _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1;
SG_GridSubshader_632ee46ba4a3cc64dad3d3d02f64eb01_float(_Property_afcbc0150b62462690fcce1af6cd55da_Out_0, _Property_db3c8d86797a492d800cd3e80f16ba77_Out_0, _GridSubshader_78b9424da3c44060bf308756fb6ccedd, _GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1);
float3 _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1;
Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1);
float3 _Add_62d7e083e61643d599daa6b7465694ed_Out_2;
Unity_Add_float3((_GridSubshader_78b9424da3c44060bf308756fb6ccedd_OutVector4_1.xyz), _Absolute_7c43b585a7d04bf4b78238bb63947bff_Out_1, _Add_62d7e083e61643d599daa6b7465694ed_Out_2);
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_R_1 = _WorldSpaceCameraPos[0];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2 = _WorldSpaceCameraPos[1];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_B_3 = _WorldSpaceCameraPos[2];
float _Split_5ab641a8c8c046a7a9d4f4143072e4b0_A_4 = 0;
float _Split_5c10ac90675449aea2f4048994b68a0b_R_1 = IN.WorldSpacePosition[0];
float _Split_5c10ac90675449aea2f4048994b68a0b_G_2 = IN.WorldSpacePosition[1];
float _Split_5c10ac90675449aea2f4048994b68a0b_B_3 = IN.WorldSpacePosition[2];
float _Split_5c10ac90675449aea2f4048994b68a0b_A_4 = 0;
float _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2;
Unity_Subtract_float(_Split_5ab641a8c8c046a7a9d4f4143072e4b0_G_2, _Split_5c10ac90675449aea2f4048994b68a0b_G_2, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2);
float _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2;
Unity_Subtract_float(75, _Subtract_4eda19882e70402f9c60c6b5b2af0993_Out_2, _Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2);
float _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2;
Unity_Divide_float(_Subtract_257ce17bd0244b68a02a5e2ebbbf4010_Out_2, 75, _Divide_57ac3fb6be02457485ca094c63b4a094_Out_2);
float _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1;
Unity_Saturate_float(_Divide_57ac3fb6be02457485ca094c63b4a094_Out_2, _Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1);
float3 _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
Unity_Multiply_float3_float3(_Add_62d7e083e61643d599daa6b7465694ed_Out_2, (_Saturate_82b74ce4b3e446c496954b14b0f738ba_Out_1.xxx), _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2);
surface.BaseColor = _Multiply_2849ae5a49384d78a77929b197c6ef6f_Out_2;
surface.Alpha = 0.5;
surface.AlphaClipThreshold = 0.5;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
    // FragInputs from VFX come from two places: Interpolator or CBuffer.
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);


    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph


    output.WorldSpacePosition = input.positionWS;
    output.VertexColor = input.color;
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

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
}
CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
FallBack "Hidden/Shader Graph/FallbackError"
}