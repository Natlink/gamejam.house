// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SandNewLight"
{
	Properties
	{
		_Wetness("Wetness", Range( 0 , 1)) = 0
		_FresnelPower("FresnelPower", Range( 0 , 2)) = 1
		_SandColor("SandColor", Color) = (0.9725491,0.7686275,0.5803922,1)
		_ShadowColors("ShadowColors", Color) = (0.9245283,0.4388708,0.2834639,1)
		_LightAttenuation("LightAttenuation", Range( 0 , 1)) = 0.8639696
		_NoiseMap("NoiseMap", 2D) = "white" {}
		_Graininess("Graininess", Range( 0 , 5)) = 0.6878181
		_NoiseDepth("NoiseDepth", Range( 1 , 100)) = 65
		_SmoothNormals("SmoothNormals", 2D) = "bump" {}
		_SmoothPower("SmoothPower", Range( 0 , 2)) = 1
		_GlitterNoise("GlitterNoise", 2D) = "white" {}
		_GlitterColor("GlitterColor", Color) = (1,1,1,0)
		_GlitterPower("GlitterPower", Range( 0 , 5)) = 1.08
		_GlitterDistance("GlitterDistance", Range( 1 , 100)) = 65
		_OceanSpecNoise("OceanSpecNoise", 2D) = "white" {}
		_OceanSpecColor("OceanSpecColor", Color) = (1,1,1,1)
		_OceanSpecSize("OceanSpecSize", Range( 1 , 200)) = 99
		_OceanNoise("OceanNoise", Range( 0 , 5)) = 1
		_OceanSpecDistance("OceanSpecDistance", Range( 1 , 100)) = 65
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _SmoothNormals;
		uniform float4 _SmoothNormals_ST;
		uniform float _SmoothPower;
		uniform sampler2D _NoiseMap;
		uniform float4 _NoiseMap_ST;
		uniform float _Graininess;
		uniform float _NoiseDepth;
		uniform float4 _ShadowColors;
		uniform float4 _SandColor;
		uniform float _LightAttenuation;
		uniform float _FresnelPower;
		uniform float _Wetness;
		uniform float4 _GlitterColor;
		uniform float _GlitterPower;
		uniform sampler2D _GlitterNoise;
		uniform float4 _GlitterNoise_ST;
		uniform float _GlitterDistance;
		uniform float _OceanSpecSize;
		uniform sampler2D _OceanSpecNoise;
		uniform float4 _OceanSpecNoise_ST;
		uniform float _OceanNoise;
		uniform float4 _OceanSpecColor;
		uniform float _OceanSpecDistance;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_SmoothNormals = i.uv_texcoord * _SmoothNormals_ST.xy + _SmoothNormals_ST.zw;
			float2 temp_output_2_0_g44 = uv_SmoothNormals;
			float2 break6_g44 = temp_output_2_0_g44;
			float temp_output_25_0_g44 = ( pow( 0.5 , 3.0 ) * 0.1 );
			float2 appendResult8_g44 = (float2(( break6_g44.x + temp_output_25_0_g44 ) , break6_g44.y));
			float4 tex2DNode14_g44 = tex2D( _SmoothNormals, temp_output_2_0_g44 );
			float temp_output_4_0_g44 = _SmoothPower;
			float3 appendResult13_g44 = (float3(1.0 , 0.0 , ( ( tex2D( _SmoothNormals, appendResult8_g44 ).g - tex2DNode14_g44.g ) * temp_output_4_0_g44 )));
			float2 appendResult9_g44 = (float2(break6_g44.x , ( break6_g44.y + temp_output_25_0_g44 )));
			float3 appendResult16_g44 = (float3(0.0 , 1.0 , ( ( tex2D( _SmoothNormals, appendResult9_g44 ).g - tex2DNode14_g44.g ) * temp_output_4_0_g44 )));
			float3 normalizeResult22_g44 = normalize( cross( appendResult13_g44 , appendResult16_g44 ) );
			float2 uv_NoiseMap = i.uv_texcoord * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
			float2 temp_output_2_0_g45 = uv_NoiseMap;
			float2 break6_g45 = temp_output_2_0_g45;
			float temp_output_25_0_g45 = ( pow( 0.5 , 3.0 ) * 0.1 );
			float2 appendResult8_g45 = (float2(( break6_g45.x + temp_output_25_0_g45 ) , break6_g45.y));
			float4 tex2DNode14_g45 = tex2D( _NoiseMap, temp_output_2_0_g45 );
			float cameraDepthFade55 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / _NoiseDepth);
			float lerpResult61 = lerp( 0.2 , _Graininess , cameraDepthFade55);
			float temp_output_4_0_g45 = lerpResult61;
			float3 appendResult13_g45 = (float3(1.0 , 0.0 , ( ( tex2D( _NoiseMap, appendResult8_g45 ).g - tex2DNode14_g45.g ) * temp_output_4_0_g45 )));
			float2 appendResult9_g45 = (float2(break6_g45.x , ( break6_g45.y + temp_output_25_0_g45 )));
			float3 appendResult16_g45 = (float3(0.0 , 1.0 , ( ( tex2D( _NoiseMap, appendResult9_g45 ).g - tex2DNode14_g45.g ) * temp_output_4_0_g45 )));
			float3 normalizeResult22_g45 = normalize( cross( appendResult13_g45 , appendResult16_g45 ) );
			float clampResult60 = clamp( ( 1.0 - cameraDepthFade55 ) , 0.0 , 1.0 );
			float3 lerpResult59 = lerp( normalizeResult22_g44 , normalizeResult22_g45 , clampResult60);
			float3 normalizeResult78 = normalize( lerpResult59 );
			o.Normal = normalizeResult78;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult93 = dot( ase_worldlightDir , ase_worldNormal );
			float clampResult96 = clamp( pow( dotResult93 , 2.45 ) , 0.5 , 1.0 );
			float4 lerpResult152 = lerp( _ShadowColors , _SandColor , clampResult96);
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float dotResult5 = dot( ase_worldlightDir , ase_worldNormal );
			float temp_output_6_0 = ( ase_lightColor.a * dotResult5 );
			float4 color14 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float clampResult15 = clamp( pow( ase_worldNormal.y , 30.0 ) , 0.0 , 0.5 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV9 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode9 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV9, 5.0 ) );
			float lerpResult103 = lerp( 1.0 , clampResult96 , ( 1.0 - ase_worldlightDir.y ));
			float4 lerpResult153 = lerp( lerpResult152 , ( ( ( temp_output_6_0 * _LightAttenuation ) * ( ( _SandColor + ( ( color14 * clampResult15 ) * 0.316035 ) ) + ( fresnelNode9 * _FresnelPower ) ) ) + ( ( ( ( 1.0 - temp_output_6_0 ) * _ShadowColors ) * 1.3 ) * lerpResult103 ) ) , _Wetness);
			float dotResult144 = dot( ase_worldlightDir , ase_worldNormal );
			float3 normalizeResult77 = normalize( ase_worldNormal );
			float fresnelNdotV73 = dot( normalizeResult77, ase_worldViewDir );
			float fresnelNode73 = ( 0.0 + 1.17 * pow( 1.0 - fresnelNdotV73, _GlitterPower ) );
			float2 uv_GlitterNoise = i.uv_texcoord * _GlitterNoise_ST.xy + _GlitterNoise_ST.zw;
			float cameraDepthFade125 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / _GlitterDistance);
			float smoothstepResult128 = smoothstep( 0.0 , 0.5 , saturate( ( 1.0 - cameraDepthFade125 ) ));
			float3 normalizeResult115 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult114 = dot( normalizeResult115 , ase_worldNormal );
			float2 uv_OceanSpecNoise = i.uv_texcoord * _OceanSpecNoise_ST.xy + _OceanSpecNoise_ST.zw;
			float4 temp_cast_0 = (_OceanNoise).xxxx;
			float cameraDepthFade140 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / _OceanSpecDistance);
			float clampResult138 = clamp( cameraDepthFade140 , 0.0 , 1.0 );
			o.Emission = saturate( ( ( ( lerpResult153 + ( _GlitterColor * saturate( ( dotResult144 * ( pow( ( fresnelNode73 * tex2D( _GlitterNoise, uv_GlitterNoise ).r ) , 14.62 ) * ( smoothstepResult128 * 2.0 ) ) ) ) ) ) + ( ( ( pow( saturate( dotResult114 ) , _OceanSpecSize ) * pow( tex2D( _OceanSpecNoise, uv_OceanSpecNoise ) , temp_cast_0 ) ) * _OceanSpecColor ) * clampResult138 ) ) * ase_lightColor ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
0;92;538;926;-24.85704;996.6553;1.312968;False;False
Node;AmplifyShaderEditor.CommentaryNode;87;35.27355,877.8677;Float;False;1510.56;969.4013;Glitter;21;127;74;70;126;67;125;73;69;124;75;77;76;128;129;133;144;145;146;147;148;149;;0.9791116,1,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;124;867.1494,1669.699;Float;False;Property;_GlitterDistance;GlitterDistance;15;0;Create;True;0;0;False;0;65;100;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;12;-1787.974,-143.2219;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;76;136.729,1124.662;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;120;1544.536,1914.876;Float;False;817.424;445.4487;blinn phong half vec;6;114;117;111;113;115;118;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CameraDepthFade;125;1130.153,1638.973;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;67.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-1197.149,445.2487;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;99;-1360.578,705.8578;Float;False;1295.33;737.8301;Shadow Emission;15;24;26;28;25;27;91;95;94;93;96;100;101;102;103;104;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;13;-1635.795,-41.04271;Float;False;2;0;FLOAT;0;False;1;FLOAT;30;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;3;-1219.249,268.4487;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;77;138.4751,1258.89;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-857.554,480.4672;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;15;-1475.897,-83.94274;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;113;1620.2,1956.829;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;75;146.8209,1400.198;Float;False;Property;_GlitterPower;GlitterPower;14;0;Create;True;0;0;False;0;1.08;1.15;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;7;-892.9545,350.1665;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;95;-912.7723,1264.688;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;94;-975.3043,1100.148;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;126;1376.542,1743.555;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;111;1576.428,2142.019;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;14;-1604.488,-375.8757;Float;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;127;1380.062,1667.799;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1218.428,-91.33475;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;0.316035;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-684.1547,453.7658;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;73;460.8741,1248.333;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.17;False;3;FLOAT;1.72;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;93;-664.8727,1174.468;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1330.374,-234.1823;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;1823.777,2049.747;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;69;496.5833,1617.269;Float;True;Property;_GlitterNoise;GlitterNoise;12;0;Create;True;0;0;False;0;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;118;1942.262,2187.621;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;26;-1053.388,755.8578;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;128;1369.517,1536.657;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;115;1974.94,2059.909;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;714.5566,1342.585;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-972.2524,-338.8365;Float;False;Property;_SandColor;SandColor;4;0;Create;True;0;0;False;0;0.9725491,0.7686275,0.5803922,1;1,0.6821352,0.4666667,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;102;-399.4902,1161.847;Float;True;2;0;FLOAT;0;False;1;FLOAT;2.45;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-1310.578,886.058;Float;False;Property;_ShadowColors;ShadowColors;5;0;Create;True;0;0;False;0;0.9245283,0.4388708,0.2834639,1;0.7264151,0.3967923,0.3186632,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1143.656,-244.7761;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1030.563,-438.3983;Float;False;Property;_FresnelPower;FresnelPower;3;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;9;-930.454,-594.6156;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-561.7897,541.9433;Float;False;Property;_LightAttenuation;LightAttenuation;6;0;Create;True;0;0;False;0;0.8639696;0.47;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;104;-622.2538,1052.06;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;1367.365,1421.76;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;96;-445.5646,1003.881;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-681.8049,-405.4519;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-797.5179,811.0353;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-687.5196,-211.1088;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;114;2148.097,2061.138;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;145;905.0051,1029.672;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;70;1003.649,1391.273;Float;True;2;0;FLOAT;0;False;1;FLOAT;14.62;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;146;861.7931,1168.893;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-805.6531,912.3171;Float;False;Constant;_Float2;Float 2;0;0;Create;True;0;0;False;0;1.3;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-297.1924,379.0458;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-487.1267,-233.0426;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;1569.959,1465.959;Float;False;Property;_OceanSpecSize;OceanSpecSize;18;0;Create;True;0;0;False;0;99;100;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;109;1729.542,1616.914;Float;True;Property;_OceanSpecNoise;OceanSpecNoise;16;0;Create;True;0;0;False;0;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;144;1108.833,1111.975;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;2074.458,1765.758;Float;False;Property;_OceanNoise;OceanNoise;19;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;1244.35,1314.36;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;103;-313.7791,881.0984;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;119;1685.345,1357.832;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-599.4681,756.4947;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;155;340.4011,342.1727;Float;False;450.8894;481.4364;Wetness;4;23;152;154;153;;0.1745283,0.8155639,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-170.457,-659.033;Float;False;1557.467;669.9972;Grainy Map;12;59;57;42;62;61;44;60;37;56;55;53;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1233.892,1212.38;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;2926.696,1868.217;Float;False;Property;_OceanSpecDistance;OceanSpecDistance;20;0;Create;True;0;0;False;0;65;70;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;108;1827.909,1367.573;Float;True;2;0;FLOAT;0;False;1;FLOAT;61.43;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;122;2083.783,1542.299;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-234.2499,769.1965;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;3.620335,303.1057;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;54.95888,-172.0049;Float;False;Property;_NoiseDepth;NoiseDepth;9;0;Create;True;0;0;False;0;65;70;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;149;645.2343,914.6437;Float;False;Property;_GlitterColor;GlitterColor;13;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraDepthFade;140;2932.583,1731.993;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;67.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;147;1227.041,1128.319;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;390.4011,392.1727;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;420.0138,708.6091;Float;False;Property;_Wetness;Wetness;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;136;2478.62,1670.169;Float;False;Property;_OceanSpecColor;OceanSpecColor;17;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;393.0304,552.2137;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;2339.83,1382.574;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;138;2943.03,1533.471;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;1208.412,947.2566;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;39.05066,-393.5482;Float;False;Property;_Graininess;Graininess;8;0;Create;True;0;0;False;0;0.6878181;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;2641.142,1389.677;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;153;607.2905,498.4228;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CameraDepthFade;55;356.1979,-144.6617;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;67.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;769.4139,-390.4882;Float;False;Property;_SmoothPower;SmoothPower;11;0;Create;True;0;0;False;0;1;0.7;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;61;335.1561,-433.9124;Float;False;3;0;FLOAT;0.2;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;44;-131.128,-605.4761;Float;True;Property;_NoiseMap;NoiseMap;7;0;Create;True;0;0;False;0;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;807.203,628.6409;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;56;678.4327,-99.5123;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;58;806.6202,-618.1631;Float;True;Property;_SmoothNormals;SmoothNormals;10;0;Create;True;0;0;False;0;066f29fd0fc3d0341b96857dcf2cede3;bd734c29baceb63499732f24fbaea45f;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;2938.08,1430.459;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;60;836.6102,-193.9526;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;134;1807.963,685.9141;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;57;1079.417,-576.4166;Float;False;NormalCreate;1;;44;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;1692.607,592.2649;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;42;498.6964,-570.3969;Float;True;NormalCreate;1;;45;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;1858.759,591.5906;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;59;1071.497,-302.1617;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;78;1330.821,63.47026;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;137;2956.749,1658.91;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;156;1872.664,515.7884;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;100;-1162.14,1092.881;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;101;-1327.601,1239.909;Float;False;Constant;_Color0;Color 0;14;0;Create;True;0;0;False;0;0.5188679,0.4038359,0.4038359,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2076.248,374.2437;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/SandNewLight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;125;0;124;0
WireConnection;13;0;12;2
WireConnection;77;0;76;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;15;0;13;0
WireConnection;126;0;125;0
WireConnection;127;0;126;0
WireConnection;6;0;7;2
WireConnection;6;1;5;0
WireConnection;73;0;77;0
WireConnection;73;3;75;0
WireConnection;93;0;94;0
WireConnection;93;1;95;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;117;0;113;0
WireConnection;117;1;111;0
WireConnection;26;0;6;0
WireConnection;128;0;127;0
WireConnection;115;0;117;0
WireConnection;67;0;73;0
WireConnection;67;1;69;1
WireConnection;102;0;93;0
WireConnection;18;0;17;0
WireConnection;18;1;16;0
WireConnection;104;0;94;2
WireConnection;129;0;128;0
WireConnection;96;0;102;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;25;0;26;0
WireConnection;25;1;24;0
WireConnection;19;0;2;0
WireConnection;19;1;18;0
WireConnection;114;0;115;0
WireConnection;114;1;118;0
WireConnection;70;0;67;0
WireConnection;31;0;6;0
WireConnection;31;1;32;0
WireConnection;8;0;19;0
WireConnection;8;1;10;0
WireConnection;144;0;146;0
WireConnection;144;1;145;0
WireConnection;74;0;70;0
WireConnection;74;1;129;0
WireConnection;103;1;96;0
WireConnection;103;2;104;0
WireConnection;119;0;114;0
WireConnection;27;0;25;0
WireConnection;27;1;28;0
WireConnection;133;0;144;0
WireConnection;133;1;74;0
WireConnection;108;0;119;0
WireConnection;108;1;121;0
WireConnection;122;0;109;0
WireConnection;122;1;123;0
WireConnection;91;0;27;0
WireConnection;91;1;103;0
WireConnection;21;0;31;0
WireConnection;21;1;8;0
WireConnection;140;0;139;0
WireConnection;147;0;133;0
WireConnection;152;0;24;0
WireConnection;152;1;2;0
WireConnection;152;2;96;0
WireConnection;23;0;21;0
WireConnection;23;1;91;0
WireConnection;110;0;108;0
WireConnection;110;1;122;0
WireConnection;138;0;140;0
WireConnection;148;0;149;0
WireConnection;148;1;147;0
WireConnection;130;0;110;0
WireConnection;130;1;136;0
WireConnection;153;0;152;0
WireConnection;153;1;23;0
WireConnection;153;2;154;0
WireConnection;55;0;53;0
WireConnection;61;1;37;0
WireConnection;61;2;55;0
WireConnection;71;0;153;0
WireConnection;71;1;148;0
WireConnection;56;0;55;0
WireConnection;141;0;130;0
WireConnection;141;1;138;0
WireConnection;60;0;56;0
WireConnection;57;1;58;0
WireConnection;57;4;62;0
WireConnection;86;0;71;0
WireConnection;86;1;141;0
WireConnection;42;1;44;0
WireConnection;42;4;61;0
WireConnection;135;0;86;0
WireConnection;135;1;134;0
WireConnection;59;0;57;0
WireConnection;59;1;42;0
WireConnection;59;2;60;0
WireConnection;78;0;59;0
WireConnection;156;0;135;0
WireConnection;100;0;24;0
WireConnection;100;1;101;0
WireConnection;100;2;93;0
WireConnection;0;1;78;0
WireConnection;0;2;156;0
ASEEND*/
//CHKSM=122F7D6E096527F10F9CBC6F25F501D2D0282D71