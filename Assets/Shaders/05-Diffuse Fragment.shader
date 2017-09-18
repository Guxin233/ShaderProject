﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/05-Diffuse Fragment" { // 逐像素漫反射
	Properties{
		_Diffuse("Diffuse Color", Color) = (1,1,1,1) // 可在编辑器面板定义材质自身色彩
	}
	SubShader{
		Pass {
			
			// 只有定义了正确的LightMode才能得到一些Unity的内置光照变量
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

// 包含unity的内置的文件，才可以使用Unity内置的一些变量
#include "Lighting.cginc" // 取得第一个直射光的颜色_LightColor0 第一个直射光的位置_WorldSpaceLightPos0（即方向）
#pragma vertex vert
#pragma fragment frag

			fixed4 _Diffuse; // 使用属性

			struct a2v
			{
				float4 vertex : POSITION;	// 告诉Unity把模型空间下的顶点坐标填充给vertex属性
				float3 normal : NORMAL;		// 告诉Unity把模型空间下的法线方向填充给normal属性
				float4 texcoord : TEXCOORD0;// 告诉Unity把第一套纹理坐标填充给texcoord属性
			};

			struct v2f
			{
				float4 position : SV_POSITION; // 声明用来存储顶点在裁剪空间下的坐标
				float3 worldNomalDir : COLOR;  // 用于存储世界空间下的法线方向
			};

			// 计算顶点坐标从模型坐标系转换到裁剪面坐标系
			v2f vert(a2v v)
			{
				v2f f;
				f.position = mul(UNITY_MATRIX_MVP, v.vertex); // UNITY_MATRIX_MVP是内置矩阵。该步骤用来把一个坐标从模型空间转换到剪裁空间
				
				// 法线方向。把法线方向从模型空间转换到世界空间
				f.worldNomalDir = (mul(v.normal, (float3x3)unity_WorldToObject)); // 反过来相乘就是从模型到世界，否则是从世界到模型
				
				return f;
			}

			// 计算每个像素点的颜色值
			fixed4 frag(v2f f) : SV_Target 
			{
				// 环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				// 法线方向。
				fixed normalDir = normalize(f.worldNomalDir); // 单位向量
				// 光照方向。
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz); // 对于每个顶点来说，光的位置就是光的方向，因为光是平行光
				// 漫反射Diffuse颜色 = 直射光颜色 * max(0, cos(光源方向和法线方向夹角)) * 材质自身色彩
				fixed3 diffuse = _LightColor0 * max(0, dot(normalDir, lightDir)) * _Diffuse; // 颜色融合用乘法
				// 加上环境光
				fixed3 tempColor = diffuse + ambient; // 颜色叠加用加法（亮度通常会增加）

				return fixed4(tempColor, 1); // tempColor是float3已经包含了三个数值
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
