// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Unlit/SmokeSim"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.BlendMode)]_SrcBlendMode("SrcBlendMode", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_DstBlendMode("DstBlendMode", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 2
		[Header(Main Texture)]_MainTexture("Main Texture", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_SecondaryColor("Secondary Color", Color) = (0,0,0,0)
		_Glow("Glow", Float) = 1
		_AlphaCoefficient("Alpha Coefficient", Float) = 1
		[Header(Soft Particle)]_Depth("Depth", Float) = 0
		_Albedo("Albedo", Color) = (0,0,0,0)
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		ZWrite Off
		Blend [_SrcBlendMode] [_DstBlendMode] , [_SrcBlendMode] [_DstBlendMode]
		
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv2_tex4coord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPosition52;
		};

		uniform float _SrcBlendMode;
		uniform float _CullMode;
		uniform float _DstBlendMode;
		uniform float4 _SecondaryColor;
		uniform float4 _MainColor;
		uniform sampler2D _MainTexture;
		SamplerState sampler_MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float _Glow;
		uniform float4 _Albedo;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _AlphaCoefficient;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos52 = ase_vertex3Pos;
			float4 ase_screenPos52 = ComputeScreenPos( UnityObjectToClipPos( vertexPos52 ) );
			o.screenPosition52 = ase_screenPos52;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult8 = (float2(i.uv2_tex4coord2.z , i.uv2_tex4coord2.w));
			float2 uv_TexCoord26 = i.uv_texcoord * _MainTexture_ST.xy + ( _MainTexture_ST.zw + ( appendResult8 * float2( 0,0 ) ) );
			float4 tex2DNode44 = tex2D( _MainTexture, uv_TexCoord26 );
			float4 lerpResult55 = lerp( _SecondaryColor , _MainColor , tex2DNode44.r);
			float4 ase_screenPos52 = i.screenPosition52;
			float4 ase_screenPosNorm52 = ase_screenPos52 / ase_screenPos52.w;
			ase_screenPosNorm52.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm52.z : ase_screenPosNorm52.z * 0.5 + 0.5;
			float screenDepth52 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm52.xy ));
			float distanceDepth52 = saturate( abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm52.z ) ) / ( _Depth ) ) );
			o.Emission = ( ( ( lerpResult55 * _Glow * tex2DNode44.r ) + ( ( tex2DNode44.g * _Albedo ) * ( 1.0 - tex2DNode44.r ) ) ) * i.vertexColor * i.vertexColor.a * distanceDepth52 ).rgb;
			float temp_output_53_0 = ( ( tex2DNode44.g * _AlphaCoefficient * i.vertexColor.a ) * distanceDepth52 );
			float clampResult59 = clamp( temp_output_53_0 , temp_output_53_0 , 1.0 );
			o.Alpha = clampResult59;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows nofog vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
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
				float3 worldPos : TEXCOORD4;
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
				o.customPack1.xyzw = customInputData.uv2_tex4coord2;
				o.customPack1.xyzw = v.texcoord1;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				o.customPack3.xyzw = customInputData.screenPosition52;
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
				surfIN.uv2_tex4coord2 = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				surfIN.screenPosition52 = IN.customPack3.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
4;320;1370;699;2286.224;309.0429;1.74402;True;False
Node;AmplifyShaderEditor.CommentaryNode;125;-3252.454,-530.7725;Inherit;False;2104.517;873.0095;Comment;13;26;17;11;12;8;3;55;50;48;129;128;44;54;Emissive;0.25178,0.4339623,0.3680638,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-3200.872,-23.94564;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-2921.224,33.24381;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2699.521,-12.44967;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;12;-2793.312,-144.9825;Inherit;False;44;False;1;0;SAMPLER2D;_Sampler012;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2521.046,11.81208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2376.49,-79.89367;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;50;-1999.213,-511.3611;Float;False;Property;_SecondaryColor;Secondary Color;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.9339623,0.1271937,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;102;-507.8573,132.5235;Inherit;False;700.0386;236.5992;Soft Particle;3;41;52;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;48;-2002.152,-307.5381;Float;False;Property;_MainColor;Main Color;5;0;Create;True;0;0;False;0;False;1,1,1,1;0.990566,0.7286175,0.5186454,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;94;-381.7885,453.171;Inherit;False;909.181;387.5741;Comment;5;59;53;49;47;42;Alpha Calculations;1,0.08018869,0.08018869,1;0;0
Node;AmplifyShaderEditor.ColorNode;174;-1322.176,74.58379;Inherit;False;Property;_Albedo;Albedo;33;0;Create;True;0;0;False;0;False;0,0,0,0;0.1981132,0.1373709,0.1373709,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;-1988.642,-41.86956;Inherit;True;Property;_MainTexture;Main Texture;4;0;Create;True;0;0;False;1;Header(Main Texture);False;-1;None;f53fc765f8ac39042b7653b8c3094339;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;41;-457.8572,182.5233;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-258.143,253.1222;Float;False;Property;_Depth;Depth;32;0;Create;True;0;0;False;1;Header(Soft Particle);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;47;-349.9872,667.1959;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-332.3663,578.0696;Float;False;Property;_AlphaCoefficient;Alpha Coefficient;31;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;184;-803.0603,216.8615;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1534.62,-87.58996;Float;False;Property;_Glow;Glow;7;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-1123.005,-17.94987;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;55;-1605.719,-255.6072;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-84.15339,503.171;Inherit;True;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-756.8517,16.14273;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;52;-75.8186,184.9425;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1056.984,-392.6733;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;160;-5988.352,2088.811;Inherit;False;2725.86;1182.65;Secondary texture to mask out the main texture;35;162;165;168;169;104;167;163;166;105;143;142;110;141;103;37;138;140;108;139;93;32;137;27;21;15;13;14;19;16;10;9;6;5;2;1;Mask Texture;0.3962264,0.3756675,0.3756675,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-3151.01,3053.504;Inherit;False;2251.152;809.438;Flow;21;72;74;77;76;75;79;80;81;82;83;84;87;86;88;73;111;112;113;114;116;117;Distortion effect;0.7373281,0.3349057,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;192.4952,523.0093;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-410.9265,-268.3749;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;101;-359.5131,2510.52;Inherit;False;2341.106;1240.034;Comment;27;89;122;119;120;121;61;58;118;57;51;98;40;43;38;36;33;28;34;18;24;132;133;130;127;135;136;134;Erosion;1,0.5058824,0.5920227,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-5074.107,3510.633;Inherit;False;1814.08;509.317;Additional Masking option to hide specific UV parts;14;153;151;152;149;146;147;155;156;158;157;154;159;145;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;56;-97.14642,-172.4716;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-4783.278,3698.323;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-2869.281,3388.408;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;83;-1845.584,3408.202;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;81;-2180.825,3265.746;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;-2461.17,3329.739;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;124;1093.876,-247.187;Inherit;False;Property;_DstBlendMode;DstBlendMode;1;0;Create;True;0;0;True;1;Enum(UnityEngine.Rendering.BlendMode);False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;1098.77,-415.2508;Inherit;False;Property;_CullMode;CullMode;2;0;Create;True;0;0;True;1;Enum(UnityEngine.Rendering.CullMode);False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;1095.75,-331.0996;Inherit;False;Property;_SrcBlendMode;SrcBlendMode;0;0;Create;True;0;0;True;1;Enum(UnityEngine.Rendering.BlendMode);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;72;-3101.01,3314.841;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-2498.832,3550.096;Float;False;Property;_IsPanning4;Is Panning ?;20;1;[Toggle];Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;113;-2949.959,3613.687;Inherit;False;Property;_XYSpeedZWClampAlpha;X/Y Speed Z/W Clamp Alpha;21;0;Create;True;0;0;False;0;False;0,0,0,1;0,0,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;-4256.15,2586.582;Inherit;False;Property;_IsEmissive;IsEmissive;16;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;169;-3996.575,2621.371;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;75;-2495.11,3469.88;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-2467.457,3174.037;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-2250.736,3484.12;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;144;-5024.107,3819.556;Inherit;False;Property;_UVMasking;U.V Masking;29;0;Create;True;0;0;False;0;False;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;59;336.0243,515.8657;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-5231.42,2851.445;Float;False;Property;_IsPanning3;Is Panning ?;13;1;[Toggle];Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;1639.786,3250.632;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-5085.237,2470.015;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-4975.42,2787.445;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;77;-2733.497,3182.27;Inherit;False;82;False;1;0;SAMPLER2D;_Sampler077;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;87;-1564.446,3103.504;Inherit;False;Property;_Flow;Flow;22;0;Create;True;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;10;-5538.336,2394.767;Inherit;False;37;False;1;0;SAMPLER2D;_Sampler010;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SamplerNode;82;-1995.467,3160.952;Inherit;True;Property;_DistortionTexture;Distortion Texture;19;0;Create;True;0;0;False;0;False;-1;None;c068f140c584612469e41c535e4aa1e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;89;1810.444,3230.203;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-5237.039,2767.417;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-5938.352,2999.515;Inherit;False;Property;_UseCustomVertexStreams3;Use Custom Vertex Streams (3.XY);15;1;[Toggle];Create;False;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-5911.74,2530.937;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;6;-5584.626,2981.551;Inherit;True;2;0;FLOAT;0.9;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-5663.397,2579.44;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-5410.389,2542.433;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1783.103,241.7677;Float;False;mainGreenChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-1794.478,308.1834;Float;False;mainBlueChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-3379.153,2325.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-3653.394,2233.887;Inherit;False;Property;_EmissiveGlow;EmissiveGlow;17;0;Create;True;0;0;False;0;False;1;0.37;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1123.855,3332.264;Inherit;False;flowedUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-3495.029,3657.928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-5244.293,2535.318;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1323.842,3260.145;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;84;-1845.938,3529.914;Inherit;False;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1472.095,3565.964;Inherit;False;Property;_ActivateEffect3;Activate Effect;18;1;[Toggle];Create;False;0;0;False;1;Header(Distortion Texture);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;117;-1639.99,3695.49;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;116;-1605.345,3741.125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;112;-1246.027,3628.617;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;86;-1481.788,3361.443;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;24;-205.454,3471.722;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;103;-4542.81,3017.462;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-5384.208,2664.771;Float;False;Property;_PannerSpeed2;Panner Speed 2;14;0;Create;True;0;0;False;0;False;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;159;-4022.11,3907.587;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-4778.958,3032.146;Inherit;False;Property;_ActivateEffect;ActivateEffect;10;1;[Toggle];Create;True;0;0;False;1;Header(Mask Texture);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;1196.99,2626.559;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-4550.769,2384.813;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;165;-4125.828,2484.581;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-4568.855,2500.205;Inherit;True;Property;_MaskTexture;MaskTexture;12;0;Create;True;0;0;False;0;False;-1;None;f53fc765f8ac39042b7653b8c3094339;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;838.5466,3021.605;Inherit;True;Property;_ErosionMap;Erosion Map;24;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;130;988.8837,2703.53;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;533.9164,3140.369;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;802.6449,2600.559;Inherit;False;128;mainGreenChannel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;139;-4688.769,2341.813;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-4914.883,2148.688;Inherit;False;129;mainBlueChannel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-3552.889,2384.167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-4408.753,3710.245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;147;-4413.068,3823.555;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;98;853.5868,3229.751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;730.1185,3235.159;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;295.761,3185.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-4610.677,3846.049;Inherit;False;Property;_MaskAlongUVs;MaskAlongUVs;28;1;[Toggle];Create;True;0;0;False;1;Header(Mask along UVs);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-4604.757,2820.222;Float;False;Property;_MaskCoefficient;Mask Coefficient;11;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-4996.534,2293.451;Inherit;False;Property;_UseBlueChannelasMask;Use Blue Channel as Mask;9;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;151;-4631.872,3711.985;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ClampOpNode;36;215.635,3384.733;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;678.8799,2781.198;Inherit;False;Property;_UseGreenChannelasErosion;Use Green Channel as Erosion;8;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;63.74408,3269.342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-4294.273,2931.685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;1470.436,3215.979;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;178.9955,-259.499;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-3839.165,2734.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;105;-4150.808,2903.385;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;1124.645,2872.56;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;448.2299,3327.513;Inherit;False;Property;_Smoothness;Smoothness;26;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;140;-4686.529,2215.782;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;119;1522.996,3474.897;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;135;986.645,2829.56;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;1194.822,3181.176;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-3676.219,3884.95;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-3843.985,3625.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-25.0899,3184.601;Inherit;False;Property;_Erosion;Erosion;25;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;-3736.417,2497.895;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;51.64508,3437.405;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;121;1330.179,3538.124;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-4814.22,2631.296;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-318.797,3346.727;Inherit;False;Property;_UseCustomVertexStreams1X;Use Custom Vertex Streams (1.X);27;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;13;-5229.064,2989.437;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;153;-4008.744,3560.633;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;1039.257,3510.937;Inherit;False;Property;_ActivateEffect2;Activate Effect;23;1;[Toggle];Create;False;0;0;False;1;Header(Erosion Effect);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;158;-3860.865,3793.295;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;934.343,3267.842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;1299.645,2761.56;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-4478.423,2138.811;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;-4247.448,3679.548;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-4032.538,3693.372;Inherit;False;Property;_Invert;Invert;30;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-4325.234,2293.375;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1141.673,-128.6402;Float;False;True;-1;4;ASEMaterialInspector;0;0;Unlit;Unlit/SmokeSim;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;3;1;True;123;10;True;124;3;1;True;123;10;True;124;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;True;126;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;3;3
WireConnection;8;1;3;4
WireConnection;11;0;8;0
WireConnection;17;0;12;1
WireConnection;17;1;11;0
WireConnection;26;0;12;0
WireConnection;26;1;17;0
WireConnection;44;1;26;0
WireConnection;184;0;44;1
WireConnection;178;0;44;2
WireConnection;178;1;174;0
WireConnection;55;0;50;0
WireConnection;55;1;48;0
WireConnection;55;2;44;1
WireConnection;49;0;44;2
WireConnection;49;1;42;0
WireConnection;49;2;47;4
WireConnection;183;0;178;0
WireConnection;183;1;184;0
WireConnection;52;1;41;0
WireConnection;52;0;46;0
WireConnection;60;0;55;0
WireConnection;60;1;54;0
WireConnection;60;2;44;1
WireConnection;53;0;49;0
WireConnection;53;1;52;0
WireConnection;179;0;60;0
WireConnection;179;1;183;0
WireConnection;145;0;19;0
WireConnection;145;1;144;0
WireConnection;76;0;72;3
WireConnection;76;1;72;4
WireConnection;83;0;82;2
WireConnection;83;1;82;3
WireConnection;81;0;79;0
WireConnection;81;2;114;0
WireConnection;81;1;80;0
WireConnection;114;0;113;1
WireConnection;114;1;113;2
WireConnection;169;0;165;0
WireConnection;79;0;77;0
WireConnection;79;1;76;0
WireConnection;80;0;75;0
WireConnection;80;1;74;0
WireConnection;59;0;53;0
WireConnection;59;1;53;0
WireConnection;122;0;120;0
WireConnection;122;1;119;0
WireConnection;19;0;10;0
WireConnection;19;1;16;0
WireConnection;27;0;15;0
WireConnection;27;1;14;0
WireConnection;27;2;13;0
WireConnection;82;1;81;0
WireConnection;89;0;122;0
WireConnection;6;1;1;0
WireConnection;5;0;2;1
WireConnection;5;1;2;2
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;128;0;44;2
WireConnection;129;0;44;3
WireConnection;167;0;163;0
WireConnection;167;1;166;0
WireConnection;73;0;88;0
WireConnection;156;0;155;0
WireConnection;156;1;157;0
WireConnection;16;0;10;1
WireConnection;16;1;9;0
WireConnection;88;0;87;0
WireConnection;88;1;86;0
WireConnection;88;2;112;0
WireConnection;84;3;83;0
WireConnection;117;0;113;3
WireConnection;116;0;113;4
WireConnection;112;1;111;0
WireConnection;86;0;84;0
WireConnection;86;1;117;0
WireConnection;86;2;116;0
WireConnection;103;1;93;0
WireConnection;159;0;149;0
WireConnection;132;0;133;0
WireConnection;132;1;130;0
WireConnection;142;0;139;0
WireConnection;142;1;37;1
WireConnection;165;1;162;0
WireConnection;37;1;32;0
WireConnection;130;1;127;0
WireConnection;43;0;38;0
WireConnection;43;1;36;0
WireConnection;139;0;137;0
WireConnection;166;0;165;0
WireConnection;166;1;143;0
WireConnection;152;0;151;0
WireConnection;152;1;151;1
WireConnection;147;1;146;0
WireConnection;98;0;43;0
WireConnection;51;0;43;0
WireConnection;51;1;40;0
WireConnection;38;0;33;0
WireConnection;38;1;34;0
WireConnection;151;0;145;0
WireConnection;36;0;28;0
WireConnection;34;0;18;0
WireConnection;110;0;108;0
WireConnection;110;1;103;0
WireConnection;120;0;61;0
WireConnection;120;1;118;0
WireConnection;62;0;179;0
WireConnection;62;1;56;0
WireConnection;62;2;56;4
WireConnection;62;3;52;0
WireConnection;168;0;169;0
WireConnection;168;1;105;0
WireConnection;105;0;110;0
WireConnection;136;0;135;0
WireConnection;136;1;57;0
WireConnection;140;1;137;0
WireConnection;119;1;121;0
WireConnection;135;0;127;0
WireConnection;61;0;134;0
WireConnection;61;1;43;0
WireConnection;61;2;58;0
WireConnection;157;0;158;0
WireConnection;157;1;159;0
WireConnection;155;0;153;0
WireConnection;155;1;154;0
WireConnection;104;1;143;0
WireConnection;104;2;168;0
WireConnection;28;0;18;0
WireConnection;28;1;24;3
WireConnection;121;0;118;0
WireConnection;32;0;19;0
WireConnection;32;2;21;0
WireConnection;32;1;27;0
WireConnection;13;0;6;0
WireConnection;153;0;149;0
WireConnection;158;0;154;0
WireConnection;58;0;98;0
WireConnection;58;1;51;0
WireConnection;134;0;132;0
WireConnection;134;1;136;0
WireConnection;141;0;138;0
WireConnection;141;1;140;0
WireConnection;149;1;152;0
WireConnection;149;2;147;0
WireConnection;143;0;141;0
WireConnection;143;1;142;0
WireConnection;0;2;62;0
WireConnection;0;9;59;0
ASEEND*/
//CHKSM=82DBE27EC9F28C9CC6C69240ECADF1E75BEE2A5E