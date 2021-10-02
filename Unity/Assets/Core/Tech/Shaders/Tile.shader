// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HexagonalTile"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		[Normal]_NormalMap("Normal Map", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_HighlightMask("HighlightMask", 2D) = "white" {}
		_HightlightGlow("HightlightGlow", Float) = 0
		_Flammes("Flammes", Range( 0 , 1)) = 0
		_Rocher("Rocher", Range( 0 , 1)) = 0
		_Flaque("Flaque", Range( 0 , 1)) = 0
		_Lave("Lave", Range( 0 , 1)) = 0
		_Glace("Glace", Range( 0 , 1)) = 0
		_TopTileMask("TopTileMask", 2D) = "white" {}
		[HideInInspector]_FlaqueWater("FlaqueWater", 2D) = "white" {}
		[HideInInspector]_LavaTex("LavaTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float4 _Tint;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _TopTileMask;
		uniform float4 _TopTileMask_ST;
		uniform float _Flammes;
		uniform float _Rocher;
		uniform sampler2D _FlaqueWater;
		uniform float _Flaque;
		uniform sampler2D _LavaTex;
		uniform float _Lave;
		uniform float _Glace;
		uniform sampler2D _HighlightMask;
		uniform float4 _HighlightMask_ST;
		uniform float _HightlightGlow;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = tex2D( _NormalMap, uv_NormalMap ).rgb;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( _Tint * tex2D( _Albedo, uv_Albedo ) ).rgb;
			float2 uv_TopTileMask = i.uv_texcoord * _TopTileMask_ST.xy + _TopTileMask_ST.zw;
			float2 uv_TexCoord64 = i.uv_texcoord * float2( 5,5 );
			float4 color58 = IsGammaSpace() ? float4(0.1249555,0.3150382,0.9811321,1) : float4(0.01434136,0.08090696,0.957614,1);
			float2 uv_TexCoord65 = i.uv_texcoord * float2( 5,5 );
			float4 color67 = IsGammaSpace() ? float4(0.8018868,0.2968506,0.1626469,1) : float4(0.6070304,0.07168924,0.02263602,1);
			float2 uv_HighlightMask = i.uv_texcoord * _HighlightMask_ST.xy + _HighlightMask_ST.zw;
			float4 color3 = IsGammaSpace() ? float4(1,0.5339494,0,1) : float4(1,0.2468205,0,1);
			float4 color20 = IsGammaSpace() ? float4(0.3053291,1,0,1) : float4(0.07590538,1,0,1);
			float4 color24 = IsGammaSpace() ? float4(0,0.09604764,1,1) : float4(0,0.009420361,1,1);
			float4 color31 = IsGammaSpace() ? float4(0,1,1,1) : float4(0,1,1,1);
			float4 color27 = IsGammaSpace() ? float4(1,0.07898478,0,1) : float4(1,0.007065244,0,1);
			o.Emission = ( 1.0 * ( ( tex2D( _TopTileMask, uv_TopTileMask ).r * ( ( 0.0 * _Flammes ) + ( 0.0 * _Rocher ) + ( ( tex2D( _FlaqueWater, uv_TexCoord64 ) * color58 ) * _Flaque ) + ( ( tex2D( _LavaTex, uv_TexCoord65 ) * color67 ) * _Lave ) + ( 0.0 * _Glace ) ) ) + ( tex2D( _HighlightMask, uv_HighlightMask ).r * _HightlightGlow * ( ( _Flammes * color3 ) + ( _Rocher * color20 ) + ( _Flaque * color24 ) + ( _Glace * color31 ) + ( _Lave * color27 ) ) ) ) ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
-21;146;1705;901;2598.845;1074.421;2.416306;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1881.936,-508.1502;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1976.162,-135.0077;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;58;-1457.237,-424.6256;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;0;False;0;False;0.1249555,0.3150382,0.9811321,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;-1641.672,-635.4083;Inherit;True;Property;_FlaqueWater;FlaqueWater;14;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;aefd654917e573a478b16ce296517e4c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;67;-1551.463,-51.48313;Inherit;False;Constant;_Color1;Color 0;15;0;Create;True;0;0;0;False;0;False;0.8018868,0.2968506,0.1626469,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-1735.898,-262.2658;Inherit;True;Property;_LavaTex;LavaTex;15;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;b76473c8544ce1b44b62bd9b3dcd89e2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1803.821,951.5301;Inherit;False;Property;_Flaque;Flaque;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1786.385,1136.154;Inherit;False;Property;_Lave;Lave;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1314.332,-142.0537;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1764.018,423.954;Inherit;False;Property;_Flammes;Flammes;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-523.9746,1058.034;Inherit;False;Constant;_HighlightColor_Lave;HighlightColor_Lave;1;0;Create;True;0;0;0;False;0;False;1,0.07898478,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-644.5189,356.8409;Inherit;False;Constant;_HighlightColor_Flammes;HighlightColor_Flammes;1;0;Create;True;0;0;0;False;0;False;1,0.5339494,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1792.666,1369.539;Inherit;False;Property;_Glace;Glace;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-660.9684,586.6144;Inherit;False;Constant;_HighlightColor_Rocher;HighlightColor_Rocher;1;0;Create;True;0;0;0;False;0;False;0.3053291,1,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-443.4362,1248.071;Inherit;False;Constant;_HighlightColor_Glace;HighlightColor_Glace;1;0;Create;True;0;0;0;False;0;False;0,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-569.9134,832.8075;Inherit;False;Constant;_HighlightColor_Flaque;HighlightColor_Flaque;1;0;Create;True;0;0;0;False;0;False;0,0.09604764,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1817.617,753.5869;Inherit;False;Property;_Rocher;Rocher;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1220.106,-515.1962;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-893.9777,-469.3782;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-325.8,696.84;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-347.8078,332.4736;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-931.5811,-848.0198;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-287.799,885.3281;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-891.0411,126.5827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-910.053,-1186.206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-875.4662,-152.1731;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-396.7004,518.1401;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-228.7276,1040.167;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-47.62469,464.0854;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-117.4722,39.00451;Inherit;True;Property;_HighlightMask;HighlightMask;5;0;Create;True;0;0;0;False;0;False;-1;None;d41d99d19903afb4d879d464a356d297;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-96.7546,304.7177;Inherit;False;Property;_HightlightGlow;HightlightGlow;6;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-576.7355,-323.6944;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-315.3684,-528.3768;Inherit;True;Property;_TopTileMask;TopTileMask;13;0;Create;True;0;0;0;False;0;False;-1;None;57ec9a8c1f6ed1b469850f51cddeee3c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;84.22779,-227.8713;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;150.0801,324.7784;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;344.6959,-67.1953;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;252.652,-931.0862;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.1661162,0.3301887,0.08254717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;212.2744,-709.1954;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;45ecdd6d6c88d8642938462c3a008265;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;279.2718,-224.7877;Inherit;False;Constant;_EffectProgress;EffectProgress;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2269.845,858.9993;Inherit;False;41;m_effectType;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2266.151,1192.341;Inherit;False;m_effectType;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;652.3527,-200.8913;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;683.064,-5.560881;Inherit;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;700.2968,92.5025;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;545.3638,-506.973;Inherit;True;Property;_NormalMap;Normal Map;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;666.1008,-809.5665;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1330.221,569.744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;40;-1449.875,1592.52;Inherit;False;2;0;FLOAT;3.9;False;1;FLOAT;4.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;26;-1447.24,1224.422;Inherit;False;2;0;FLOAT;3.5;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1317.464,800.0616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;37;-1484.733,835.0511;Inherit;False;2;0;FLOAT;0.9;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;30;-1454.587,1486.407;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;39;-1459.547,1317.435;Inherit;False;2;0;FLOAT;2.9;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;-1462.799,1073.815;Inherit;False;2;0;FLOAT;1.9;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;14;-1507.869,491.2833;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1308.413,1567.314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;-1469.952,981.6121;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1314.477,1000.519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;18;-1487.939,747.1548;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;36;-1483.864,617.2603;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1285.674,1258.398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2313.33,1090.78;Inherit;False;Property;_EffectType;EffectType;7;3;[HideInInspector];[IntRange];[Enum];Create;True;0;5;Flammes;0;Rocher;1;Flaque;2;Lave;3;Glace;4;0;False;0;False;0;3;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1034.82,-155.4618;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HexagonalTile;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;61;1;64;0
WireConnection;66;1;65;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;59;0;61;0
WireConnection;59;1;58;0
WireConnection;54;0;59;0
WireConnection;54;1;23;0
WireConnection;49;0;23;0
WireConnection;49;1;24;0
WireConnection;47;0;15;0
WireConnection;47;1;3;0
WireConnection;53;1;19;0
WireConnection;50;0;28;0
WireConnection;50;1;27;0
WireConnection;56;1;32;0
WireConnection;52;1;15;0
WireConnection;55;0;68;0
WireConnection;55;1;28;0
WireConnection;48;0;19;0
WireConnection;48;1;20;0
WireConnection;51;0;32;0
WireConnection;51;1;31;0
WireConnection;16;0;47;0
WireConnection;16;1;48;0
WireConnection;16;2;49;0
WireConnection;16;3;51;0
WireConnection;16;4;50;0
WireConnection;57;0;52;0
WireConnection;57;1;53;0
WireConnection;57;2;54;0
WireConnection;57;3;55;0
WireConnection;57;4;56;0
WireConnection;46;0;44;1
WireConnection;46;1;57;0
WireConnection;2;0;1;1
WireConnection;2;1;12;0
WireConnection;2;2;16;0
WireConnection;45;0;46;0
WireConnection;45;1;2;0
WireConnection;41;0;33;0
WireConnection;43;0;11;0
WireConnection;43;1;45;0
WireConnection;5;0;6;0
WireConnection;5;1;4;0
WireConnection;13;0;14;0
WireConnection;13;1;36;0
WireConnection;40;1;33;0
WireConnection;26;0;33;0
WireConnection;17;0;18;0
WireConnection;17;1;37;0
WireConnection;37;1;33;0
WireConnection;30;0;33;0
WireConnection;39;1;33;0
WireConnection;38;1;33;0
WireConnection;14;0;33;0
WireConnection;29;0;30;0
WireConnection;29;1;40;0
WireConnection;22;0;33;0
WireConnection;21;0;22;0
WireConnection;21;1;38;0
WireConnection;18;0;33;0
WireConnection;36;1;33;0
WireConnection;25;0;26;0
WireConnection;25;1;39;0
WireConnection;0;0;5;0
WireConnection;0;1;7;0
WireConnection;0;2;43;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
ASEEND*/
//CHKSM=08A737095A0E2E8569EB11382920047C9952B0E5