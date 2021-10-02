// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Unlit/Smoke"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_SecondaryColor("Secondary Color", Color) = (0,0,0,0)
		_Glow("Glow", Float) = 1
		_SecondTexture("Second Texture", 2D) = "white" {}
		_PannerSpeed3("Panner Speed 3", Vector) = (0.02,-0.05,0,0)
		_PannerSpeed2("Panner Speed 2", Vector) = (1,0,0,0)
		_ThirdTexture("Third Texture", 2D) = "white" {}
		_AlphaCoefficient("Alpha Coefficient", Float) = 2
		[Toggle]_IsPanning2("Is Panning ?", Float) = 1
		[Toggle]_IsPanning3("Is Panning ?", Float) = 1
		_Depth("Depth", Float) = 0
		_FFogColor("FFog Color", Color) = (0,0,0,0)
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		LOD 100
		Cull Back
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float4 uv2_tex4coord2;
			float4 screenPos;
		};

		uniform float4 _FFogColor;
		uniform float4 _MainColor;
		uniform float _Glow;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float4 _SecondaryColor;
		uniform sampler2D _SecondTexture;
		uniform float _IsPanning2;
		uniform float2 _PannerSpeed2;
		uniform sampler2D _Sampler024;
		uniform float4 _SecondTexture_ST;
		uniform sampler2D _ThirdTexture;
		uniform float _IsPanning3;
		uniform float2 _PannerSpeed3;
		uniform sampler2D _Sampler025;
		uniform float4 _ThirdTexture_ST;
		uniform float _AlphaCoefficient;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Depth;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform49 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float temp_output_55_0 = saturate( distance( transform49 , float4( _WorldSpaceCameraPos , 0.0 ) ) );
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTexture, uv_MainTexture );
			float smoothstepResult66 = smoothstep( 0.3 , 1.0 , tex2DNode2.r);
			float4 lerpResult63 = lerp( _SecondaryColor , _MainColor , smoothstepResult66);
			o.Emission = ( ( temp_output_55_0 * _FFogColor ) * ( _MainColor * _Glow * i.vertexColor * tex2DNode2 * lerpResult63 ) ).rgb;
			float2 uv_TexCoord15 = i.uv_texcoord * _SecondTexture_ST.xy + i.uv2_texcoord2;
			float2 panner14 = ( ( _Time.y * _IsPanning2 ) * _PannerSpeed2 + uv_TexCoord15);
			float4 appendResult31 = (float4(i.uv2_tex4coord2.z , i.uv2_tex4coord2.w , 0.0 , 0.0));
			float2 uv_TexCoord19 = i.uv_texcoord * _ThirdTexture_ST.xy + appendResult31.xy;
			float2 panner22 = ( ( _Time.y * _IsPanning3 ) * _PannerSpeed3 + uv_TexCoord19);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth36 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth36 = saturate( abs( ( screenDepth36 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) ) );
			float temp_output_9_0 = ( tex2DNode2.a * tex2D( _SecondTexture, panner14 ).r * tex2D( _ThirdTexture, panner22 ).g * _AlphaCoefficient * i.vertexColor.a * distanceDepth36 );
			o.Alpha = temp_output_9_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float4 screenPos : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.customPack2.xyzw = customInputData.uv2_tex4coord2;
				o.customPack2.xyzw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				surfIN.uv2_tex4coord2 = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
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
Version=16100
-896;36;880;1010;707.2559;704.358;1.93262;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;48;-164.2034,-925.8367;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;30;-1671.523,636.8823;Float;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;28;-1439.89,134.4296;Float;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;25;-1424.84,510.2531;Float;False;12;1;0;SAMPLER2D;_Sampler025;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.WorldSpaceCameraPos;47;-32.43436,-630.9731;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;49;80.7863,-844.9073;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-586.9433,-81.0738;Float;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;0;8c5d1deba5b9d8140899087b561de75c;fdeb5edeeaa9f37408869fc0a4ab60c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1186.453,797.8638;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1190.174,878.0787;Float;False;Property;_IsPanning3;Is Panning ?;11;1;[Toggle];Create;False;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1125.618,299.9721;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1120,384;Float;False;Property;_IsPanning2;Is Panning ?;10;1;[Toggle];Create;False;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;24;-1399.119,21.68466;Float;False;3;1;0;SAMPLER2D;_Sampler024;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.DynamicAppendNode;31;-1430.479,654.664;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;64;-652.9156,-293.2849;Float;False;Property;_SecondaryColor;Secondary Color;3;0;Create;True;0;0;False;0;0,0,0,0;0.8726415,0.9829994,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;16;-1113.33,181.1421;Float;False;Property;_PannerSpeed2;Panner Speed 2;7;0;Create;True;0;0;False;0;1,0;0.02,-0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;51;348.0198,-724.1309;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;66;-234.2914,-241.5228;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-522.0195,-457.2828;Float;False;Property;_MainColor;Main Color;1;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-942.0775,812.1029;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1123.805,66.45537;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;21;-1191.097,651.3541;Float;False;Property;_PannerSpeed3;Panner Speed 3;6;0;Create;True;0;0;False;0;0.02,-0.05;-0.05,-0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1158.799,502.0209;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-864,320;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;29;-307.0974,276.4848;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;55;606.4555,-730.3271;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-792.8702,-409.1369;Float;False;Property;_Depth;Depth;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-426.1302,-198.9722;Float;False;Property;_Glow;Glow;4;0;Create;True;0;0;False;0;1;2.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-859.5201,196.1342;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;22;-872.1673,593.7284;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;63;-235.4506,-464.8105;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;318.7198,-461.5076;Float;False;Property;_FFogColor;FFog Color;13;0;Create;True;0;0;False;0;0,0,0,0;0.7242346,0.7988304,0.8773585,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;600.6527,-547.7731;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;76.11178,-229.8516;Float;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;36;-311.9953,749.9855;Float;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-592.8569,153.6358;Float;True;Property;_SecondTexture;Second Texture;5;0;Create;True;0;0;False;0;c068f140c584612469e41c535e4aa1e7;c068f140c584612469e41c535e4aa1e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-608.3438,492.8583;Float;True;Property;_ThirdTexture;Third Texture;8;0;Create;True;0;0;False;0;c068f140c584612469e41c535e4aa1e7;c068f140c584612469e41c535e4aa1e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-556.1094,715.4462;Float;False;Property;_AlphaCoefficient;Alpha Coefficient;9;0;Create;True;0;0;False;0;2;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;298.763,422.046;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;58;-64.70283,-1171.847;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraDepthFade;56;393.8307,-938.9437;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;11.5;False;1;FLOAT;1.74;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;57;323.5392,-1179.245;Float;False;float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(screenPos)))) - _ProjectionParams.y)@$                float partZ = max(0,screenPos.z - _ProjectionParams.y)@$			 factor=saturate((sceneZ-partZ)/Depth)@$$;1;False;3;True;screenPos;FLOAT;0;In;;Float;True;Depth;FLOAT;0;In;;Float;True;factor;FLOAT;0;Out;;Float;Depth Expression;True;False;0;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;2;FLOAT;0;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;61;39.44077,-546.389;Float;False;Constant;_Vector0;Vector 0;13;0;Create;True;0;0;False;0;-0.03,0,-0.74;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;62;803.5256,-712.9614;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;8.618851,199.6601;Float;True;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;672.386,-321.1578;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;46;172.3582,1.350903;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;40;-110.848,-404.896;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,1;False;2;COLOR;1,1,1,1;False;3;COLOR;-2,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;721.9846,-87.656;Float;False;True;4;Float;ASEMaterialInspector;100;0;Unlit;Unlit/Smoke;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;True;0;True;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;100;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;48;0
WireConnection;31;0;30;3
WireConnection;31;1;30;4
WireConnection;51;0;49;0
WireConnection;51;1;47;0
WireConnection;66;0;2;1
WireConnection;35;0;20;0
WireConnection;35;1;34;0
WireConnection;15;0;24;0
WireConnection;15;1;28;0
WireConnection;19;0;25;0
WireConnection;19;1;31;0
WireConnection;33;0;17;0
WireConnection;33;1;32;0
WireConnection;55;0;51;0
WireConnection;14;0;15;0
WireConnection;14;2;16;0
WireConnection;14;1;33;0
WireConnection;22;0;19;0
WireConnection;22;2;21;0
WireConnection;22;1;35;0
WireConnection;63;0;64;0
WireConnection;63;1;7;0
WireConnection;63;2;66;0
WireConnection;52;0;55;0
WireConnection;52;1;53;0
WireConnection;10;0;7;0
WireConnection;10;1;11;0
WireConnection;10;2;29;0
WireConnection;10;3;2;0
WireConnection;10;4;63;0
WireConnection;36;0;38;0
WireConnection;3;1;14;0
WireConnection;12;1;22;0
WireConnection;67;0;9;0
WireConnection;56;2;48;0
WireConnection;57;0;58;0
WireConnection;57;1;38;0
WireConnection;62;0;55;0
WireConnection;9;0;2;4
WireConnection;9;1;3;1
WireConnection;9;2;12;2
WireConnection;9;3;13;0
WireConnection;9;4;29;4
WireConnection;9;5;36;0
WireConnection;54;0;52;0
WireConnection;54;1;10;0
WireConnection;40;0;2;0
WireConnection;5;2;54;0
WireConnection;5;9;9;0
ASEEND*/
//CHKSM=ACB040EACA4E255A09A56D9AB0AED5C2F2D579F1