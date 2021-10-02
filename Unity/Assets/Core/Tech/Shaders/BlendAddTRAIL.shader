// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Unlit/Trails/BlendAdd"
{
	Properties
	{
		[Header(Main Texture)]_MainTexture("Main Texture", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_SecondaryColor("Secondary Color", Color) = (0,0,0,0)
		_Glow("Glow", Float) = 1
		[Toggle]_UseCustomVertexStreams1("Use Custom Vertex Streams", Float) = 0
		[Toggle]_IsPanning("Is Panning ?", Float) = 1
		_UVPanningSPEED("UV Panning SPEED", Vector) = (1,0,0,0)
		[Header(Erosion Texture)]_SecondTexture("Second Texture", 2D) = "white" {}
		[Toggle]_IsPanning2("Is Panning ?", Float) = 1
		_PannerSpeed2("Panner Speed 2", Vector) = (1,0,0,0)
		[Toggle]_UseCustomVertexStreams2("Use Custom Vertex Streams", Float) = 0
		_ClampAlpha2("ClampAlpha", Vector) = (1,1,0,0)
		[Header(Flow Texture)]_ThirdTexture("Third Texture", 2D) = "white" {}
		_PannerSpeed3("Panner Speed 3", Vector) = (0.02,-0.05,0,0)
		[Toggle]_IsPanning3("Is Panning ?", Float) = 1
		_Flow("Flow", Range( 0 , 2)) = 0
		_FlowDistance("FlowDistance", Range( 0 , 1)) = 1
		_ClampAlpha3("ClampAlpha", Vector) = (0,1,0,0)
		_AlphaCoefficient("Alpha Coefficient", Float) = 2
		_Depth("Depth", Float) = 0
		_FFogColor("FFog Color", Color) = (0,0,0,0)
		[Header(Masking Texture)]_FourthTexture("Fourth Texture", 2D) = "white" {}
		_Erosion("Erosion", Range( 1 , 5)) = 0
		_Smoothness("Smoothness", Range( 0.01 , 1.1)) = 0.5358259
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord3( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float4 uv3_tex4coord3;
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 vertexColor : COLOR;
			float4 screenPosition36;
		};

		uniform float4 _FFogColor;
		uniform float4 _SecondaryColor;
		uniform float4 _MainColor;
		uniform sampler2D _MainTexture;
		uniform float _IsPanning;
		uniform float _UseCustomVertexStreams1;
		uniform float2 _UVPanningSPEED;
		uniform sampler2D _ThirdTexture;
		uniform float _IsPanning3;
		uniform float2 _PannerSpeed3;
		uniform sampler2D _Sampler025;
		uniform float4 _ThirdTexture_ST;
		uniform float2 _ClampAlpha3;
		uniform float _Flow;
		uniform sampler2D _Sampler0101;
		uniform float4 _MainTexture_ST;
		uniform float _FlowDistance;
		uniform float _Glow;
		uniform sampler2D _SecondTexture;
		uniform float _IsPanning2;
		uniform float _UseCustomVertexStreams2;
		uniform float2 _PannerSpeed2;
		uniform sampler2D _Sampler024;
		uniform float4 _SecondTexture_ST;
		uniform float2 _ClampAlpha2;
		uniform float _Smoothness;
		uniform sampler2D _FourthTexture;
		uniform float4 _FourthTexture_ST;
		uniform float _Erosion;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _AlphaCoefficient;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos36 = ase_vertex3Pos;
			float4 ase_screenPos36 = ComputeScreenPos( UnityObjectToClipPos( vertexPos36 ) );
			o.screenPosition36 = ase_screenPos36;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform49 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float temp_output_98_0 = step( 0.9 , _UseCustomVertexStreams1 );
			float2 appendResult127 = (float2(i.uv3_tex4coord3.z , i.uv3_tex4coord3.w));
			float2 uv_TexCoord19 = i.uv_texcoord * _ThirdTexture_ST.xy + appendResult127;
			float2 panner22 = ( ( _Time.y * _IsPanning3 ) * _PannerSpeed3 + uv_TexCoord19);
			float4 tex2DNode12 = tex2D( _ThirdTexture, panner22 );
			float2 appendResult140 = (float2(tex2DNode12.g , tex2DNode12.b));
			float2 temp_cast_2 = (_ClampAlpha3.x).xx;
			float2 temp_cast_3 = (_ClampAlpha3.y).xx;
			float2 clampResult86 = clamp( ( ( appendResult140 + -0.5 ) * 2.0 ) , temp_cast_2 , temp_cast_3 );
			float2 appendResult126 = (float2(i.uv2_tex4coord2.z , i.uv2_tex4coord2.w));
			float2 uv_TexCoord106 = i.uv_texcoord * _MainTexture_ST.xy + ( _MainTexture_ST.zw + ( appendResult126 * temp_output_98_0 ) );
			float lerpResult146 = lerp( 1.0 , ( uv_TexCoord106.x * uv_TexCoord106.y ) , _FlowDistance);
			float2 panner107 = ( ( _Time.y * _IsPanning * ( 1.0 - temp_output_98_0 ) ) * _UVPanningSPEED + ( ( clampResult86 * _Flow * lerpResult146 ) + uv_TexCoord106 ));
			float4 tex2DNode2 = tex2D( _MainTexture, panner107 );
			float4 lerpResult63 = lerp( _SecondaryColor , _MainColor , tex2DNode2.r);
			float temp_output_88_0 = step( 0.9 , _UseCustomVertexStreams2 );
			float2 appendResult94 = (float2(i.uv3_tex4coord3.x , i.uv3_tex4coord3.y));
			float2 uv_TexCoord15 = i.uv_texcoord * _SecondTexture_ST.xy + ( _SecondTexture_ST.zw + ( appendResult94 * temp_output_88_0 ) );
			float2 panner14 = ( ( _Time.y * _IsPanning2 * ( 1.0 - temp_output_88_0 ) ) * _PannerSpeed2 + uv_TexCoord15);
			float temp_output_133_0 = saturate( ( (_ClampAlpha2.x + (tex2D( _SecondTexture, panner14 ).r - 0.0) * (_ClampAlpha2.y - _ClampAlpha2.x) / (1.0 - 0.0)) - uv_TexCoord15.x ) );
			float4 temp_cast_4 = (_Smoothness).xxxx;
			float2 uv_FourthTexture = i.uv_texcoord * _FourthTexture_ST.xy + _FourthTexture_ST.zw;
			float4 temp_cast_5 = (_Erosion).xxxx;
			float4 smoothstepResult148 = smoothstep( float4( 0,0,0,0 ) , temp_cast_4 , pow( tex2D( _FourthTexture, uv_FourthTexture ) , temp_cast_5 ));
			float2 uv153 = uv_TexCoord106;
			float2 break155 = uv153;
			float4 temp_cast_6 = (break155.x).xxxx;
			float4 temp_output_169_0 = saturate( pow( smoothstepResult148 , temp_cast_6 ) );
			float4 ase_screenPos36 = i.screenPosition36;
			float4 ase_screenPosNorm36 = ase_screenPos36 / ase_screenPos36.w;
			ase_screenPosNorm36.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm36.z : ase_screenPosNorm36.z * 0.5 + 0.5;
			float screenDepth36 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm36.xy ));
			float distanceDepth36 = saturate( abs( ( screenDepth36 - LinearEyeDepth( ase_screenPosNorm36.z ) ) / ( _Depth ) ) );
			o.Emission = ( ( saturate( distance( transform49 , float4( _WorldSpaceCameraPos , 0.0 ) ) ) * _FFogColor ) * ( lerpResult63 * _Glow * i.vertexColor * tex2DNode2 * temp_output_133_0 ) * temp_output_169_0 * distanceDepth36 ).rgb;
			float temp_output_76_0 = ( ( tex2DNode2.r * temp_output_133_0 * _AlphaCoefficient * i.vertexColor.a ) * distanceDepth36 );
			float clampResult69 = clamp( temp_output_76_0 , temp_output_76_0 , 1.0 );
			o.Alpha = ( clampResult69 * temp_output_169_0 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float4 customPack3 : TEXCOORD3;
				float4 customPack4 : TEXCOORD4;
				float3 worldPos : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xyzw = customInputData.uv3_tex4coord3;
				o.customPack1.xyzw = v.texcoord2;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				o.customPack3.xyzw = customInputData.uv2_tex4coord2;
				o.customPack3.xyzw = v.texcoord1;
				o.customPack4.xyzw = customInputData.screenPosition36;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv3_tex4coord3 = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				surfIN.uv2_tex4coord2 = IN.customPack3.xyzw;
				surfIN.screenPosition36 = IN.customPack4.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "4"
}
/*ASEBEGIN
Version=17200
-1303;1;1227;1011;2693.25;1972.753;2.451014;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;30;-2849.744,-1338.273;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;-2423.196,-380.8956;Inherit;False;Property;_UseCustomVertexStreams1;Use Custom Vertex Streams;4;1;[Toggle];Create;False;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;95;-2425.785,-700.5892;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;20;-2438.602,-1216.305;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;25;-2676.989,-1503.915;Inherit;False;12;1;0;SAMPLER2D;_Sampler025;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;34;-2442.323,-1136.09;Float;False;Property;_IsPanning3;Is Panning ?;14;1;[Toggle];Create;False;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;127;-2641.906,-1303.289;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;21;-2443.246,-1362.814;Float;False;Property;_PannerSpeed3;Panner Speed 3;13;0;Create;True;0;0;False;0;0.02,-0.05;0.02,-0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;126;-2146.136,-643.3997;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;98;-2072.006,-398.8604;Inherit;True;2;0;FLOAT;0.9;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2194.227,-1202.066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2410.948,-1512.147;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;22;-2124.316,-1420.44;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1924.433,-689.0932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;101;-2014.284,-857.0773;Inherit;False;2;1;0;SAMPLER2D;_Sampler0101;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;12;-1860.493,-1521.31;Inherit;True;Property;_ThirdTexture;Third Texture;12;0;Create;True;0;0;False;1;Header(Flow Texture);-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;28;-2368.828,52.18976;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;89;-2542.969,556.83;Inherit;False;Property;_UseCustomVertexStreams2;Use Custom Vertex Streams;10;1;[Toggle];Create;False;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-1742.018,-700.2827;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-1522.844,-1635.097;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1594.202,-791.9884;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;94;-2120.485,100.6925;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;88;-2189.243,538.8653;Inherit;True;2;0;FLOAT;0.9;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1867.476,63.68584;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-1468.545,-1015.85;Inherit;False;Property;_FlowDistance;FlowDistance;16;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-1362.795,-1125.667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;78;-1798.148,-1259.729;Inherit;False;Property;_ClampAlpha3;ClampAlpha;17;0;Create;False;0;0;False;0;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureTransformNode;24;-1995.424,-83.98022;Inherit;False;3;1;0;SAMPLER2D;_Sampler024;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.FunctionNode;141;-1523.198,-1513.386;Inherit;False;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1841.655,324.7325;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;146;-1189.936,-1160.24;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-1833.681,546.7518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-1352.755,-1291.48;Inherit;False;Property;_Flow;Flow;15;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1836.037,408.7603;Float;False;Property;_IsPanning2;Is Panning ?;8;1;[Toggle];Create;False;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-1701.381,56.57076;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;86;-1258.629,-1456.02;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1542.325,-8.732187;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1580.037,344.7602;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;16;-1841.295,186.0234;Float;False;Property;_PannerSpeed2;Panner Speed 2;9;0;Create;True;0;0;False;0;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-978.1778,-1379.723;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;143;-901.998,-1043.033;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;14;-1338.995,123.4864;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;103;-1735.799,-190.9735;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;142;-1195.667,-860.2527;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;100;-1743.773,-412.9928;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;75;-892.6348,346.0174;Inherit;False;Property;_ClampAlpha2;ClampAlpha;11;0;Create;False;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;102;-1738.155,-328.965;Float;False;Property;_IsPanning;Is Panning ?;5;1;[Toggle];Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1077.237,107.1412;Inherit;True;Property;_SecondTexture;Second Texture;7;0;Create;True;0;0;False;1;Header(Erosion Texture);-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;104;-1743.413,-551.702;Float;False;Property;_UVPanningSPEED;UV Panning SPEED;6;0;Create;True;0;0;False;0;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-1149.304,-830.9883;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1482.155,-392.9654;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;74;-676.232,224.5643;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;48;-239.4859,-1025.209;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;135;-449.3255,264.6641;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;107;-1188.885,-431.7475;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;112;-20.93944,924.8625;Inherit;True;Property;_FourthTexture;Fourth Texture;21;0;Create;True;0;0;False;1;Header(Masking Texture);-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;48.59685,1205.85;Inherit;False;Property;_Erosion;Erosion;22;0;Create;True;0;0;False;0;0;0;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;-1363.2,-674.3183;Inherit;False;uv;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;511.3069,1055.192;Inherit;False;153;uv;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;49;11.5264,-992.4609;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;47;-38.45696,-811.6509;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;147;317.3291,597.7955;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-576.4846,965.6221;Float;False;Property;_Depth;Depth;19;0;Create;True;0;0;False;0;0;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-629.9083,704.7354;Float;False;Property;_AlphaCoefficient;Alpha Coefficient;18;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;170;-610.0692,807.9103;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-785.4859,-303.565;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;1;Header(Main Texture);-1;None;61d635843f21b8046aa7bb1dad4bece7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;93;-347.6689,563.7744;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;117;316.1908,895.7452;Inherit;False;Property;_Smoothness;Smoothness;23;0;Create;True;0;0;False;0;0.5358259;0.5358259;0.01;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;133;-214.497,222.5898;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;64;-777.3001,-729.7916;Float;False;Property;_SecondaryColor;Secondary Color;2;0;Create;True;0;0;False;0;0,0,0,0;1,0.2328192,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-9.828438,248.0842;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-794.1811,-563.8118;Float;False;Property;_MainColor;Main Color;1;0;Create;True;0;0;False;0;1,1,1,1;1,0.3537736,0.4963796,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;36;-271.6481,810.7064;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;155;714.824,1046.028;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;51;266.7147,-943.9556;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;148;608.061,673.5247;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;264.5163,-699.4001;Float;False;Property;_FFogColor;FFog Color;20;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;29;-189.1316,-163.3798;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;55;537.1957,-877.8807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-166.1314,-330.6754;Float;False;Property;_Glow;Glow;3;0;Create;True;0;0;False;0;1;2.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;218.2089,313.7536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;-363.0939,-540.674;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;163;953.7806,488.202;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1.05;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;69;445.3572,292.2842;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;169;1044.948,414.142;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;534.4042,-779.643;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;85.37138,-348.1543;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;165;952.5696,1481.584;Inherit;False;Constant;_Float0;Float 0;25;0;Create;True;0;0;False;0;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;56;8.487505,-1115.269;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;11.5;False;1;FLOAT;1.74;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;1316.898,1383.322;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;58;109.9526,-1719.904;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;156;807.5891,1255.174;Inherit;False;Property;_erosionDistance;erosionDistance;24;0;Create;True;0;0;False;0;0;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;1579.884,1055.19;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;160;1330.749,1206.392;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;899.2806,210.6748;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;57;498.1947,-1727.302;Float;False;float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(screenPos)))) - _ProjectionParams.y)@$                float partZ = max(0,screenPos.z - _ProjectionParams.y)@$			 factor=saturate((sceneZ-partZ)/Depth)@$$;1;False;3;True;screenPos;FLOAT;0;In;;Float;False;True;Depth;FLOAT;0;In;;Float;False;True;factor;FLOAT;0;Out;;Float;False;Depth Expression;True;False;0;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;2;FLOAT;0;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;162;1554.006,1310.417;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;724.1542,-347.4333;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;161;1130.068,1270.129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;1107.49,-140.9784;Float;False;True;7;4;0;0;Standard;Unlit/Trails/BlendAdd;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;127;0;30;3
WireConnection;127;1;30;4
WireConnection;126;0;95;3
WireConnection;126;1;95;4
WireConnection;98;1;96;0
WireConnection;35;0;20;0
WireConnection;35;1;34;0
WireConnection;19;0;25;0
WireConnection;19;1;127;0
WireConnection;22;0;19;0
WireConnection;22;2;21;0
WireConnection;22;1;35;0
WireConnection;99;0;126;0
WireConnection;99;1;98;0
WireConnection;12;1;22;0
WireConnection;109;0;101;1
WireConnection;109;1;99;0
WireConnection;140;0;12;2
WireConnection;140;1;12;3
WireConnection;106;0;101;0
WireConnection;106;1;109;0
WireConnection;94;0;28;1
WireConnection;94;1;28;2
WireConnection;88;1;89;0
WireConnection;91;0;94;0
WireConnection;91;1;88;0
WireConnection;144;0;106;1
WireConnection;144;1;106;2
WireConnection;141;3;140;0
WireConnection;146;1;144;0
WireConnection;146;2;145;0
WireConnection;92;0;88;0
WireConnection;110;0;24;1
WireConnection;110;1;91;0
WireConnection;86;0;141;0
WireConnection;86;1;78;1
WireConnection;86;2;78;2
WireConnection;15;0;24;0
WireConnection;15;1;110;0
WireConnection;33;0;17;0
WireConnection;33;1;32;0
WireConnection;33;2;92;0
WireConnection;138;0;86;0
WireConnection;138;1;139;0
WireConnection;138;2;146;0
WireConnection;143;0;138;0
WireConnection;14;0;15;0
WireConnection;14;2;16;0
WireConnection;14;1;33;0
WireConnection;103;0;98;0
WireConnection;142;0;143;0
WireConnection;3;1;14;0
WireConnection;137;0;142;0
WireConnection;137;1;106;0
WireConnection;105;0;100;0
WireConnection;105;1;102;0
WireConnection;105;2;103;0
WireConnection;74;0;3;1
WireConnection;74;3;75;1
WireConnection;74;4;75;2
WireConnection;135;0;74;0
WireConnection;135;1;15;1
WireConnection;107;0;137;0
WireConnection;107;2;104;0
WireConnection;107;1;105;0
WireConnection;153;0;106;0
WireConnection;49;0;48;0
WireConnection;147;0;112;0
WireConnection;147;1;113;0
WireConnection;2;1;107;0
WireConnection;133;0;135;0
WireConnection;9;0;2;1
WireConnection;9;1;133;0
WireConnection;9;2;13;0
WireConnection;9;3;93;4
WireConnection;36;1;170;0
WireConnection;36;0;38;0
WireConnection;155;0;154;0
WireConnection;51;0;49;0
WireConnection;51;1;47;0
WireConnection;148;0;147;0
WireConnection;148;2;117;0
WireConnection;55;0;51;0
WireConnection;76;0;9;0
WireConnection;76;1;36;0
WireConnection;63;0;64;0
WireConnection;63;1;7;0
WireConnection;63;2;2;1
WireConnection;163;0;148;0
WireConnection;163;1;155;0
WireConnection;69;0;76;0
WireConnection;69;1;76;0
WireConnection;169;0;163;0
WireConnection;52;0;55;0
WireConnection;52;1;53;0
WireConnection;10;0;63;0
WireConnection;10;1;11;0
WireConnection;10;2;29;0
WireConnection;10;3;2;0
WireConnection;10;4;133;0
WireConnection;56;2;48;0
WireConnection;164;0;155;0
WireConnection;164;1;148;0
WireConnection;164;2;165;0
WireConnection;150;0;148;0
WireConnection;150;1;160;0
WireConnection;160;0;155;1
WireConnection;160;1;161;0
WireConnection;114;0;69;0
WireConnection;114;1;169;0
WireConnection;57;0;58;0
WireConnection;162;0;148;0
WireConnection;162;2;164;0
WireConnection;54;0;52;0
WireConnection;54;1;10;0
WireConnection;54;2;169;0
WireConnection;54;3;36;0
WireConnection;161;0;156;0
WireConnection;5;2;54;0
WireConnection;5;9;114;0
ASEEND*/
//CHKSM=84AD03F3CEA593D9FB5C7DCD79C8773733E4EBF2