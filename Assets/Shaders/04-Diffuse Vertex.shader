Shader "Custom/04-Diffuse Vertex" { // 顶点漫反射，逐顶点光照

	SubShader{
		Pass {
			
			// 只有定义了正确的LightMode才能得到一些Unity的内置光照变量
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

// 包含unity的内置的文件，才可以使用Unity内置的一些变量
#include "Lighting.cginc" // 取得第一个直射光的颜色_LightColor0 第一个直射光的位置_WorldSpaceLightPos0（即方向）
#pragma vertex vert
#pragma fragment frag

			struct a2v
			{
				float4 vertex : POSITION;	// 告诉Unity把模型空间下的顶点坐标填充给vertex属性
				float3 normal : NORMAL;		// 告诉Unity把模型空间下的法线方向填充给normal属性
				float4 texcoord : TEXCOORD0;// 告诉Unity把第一套纹理坐标填充给texcoord属性
			};

			struct v2f
			{
				float4 position : SV_POSITION;
				float3 color : COLOR; // 用于传递计算出来的漫反射颜色
			};

			// 计算顶点坐标从模型坐标系转换到裁剪面坐标系
			v2f vert(a2v v)
			{
				v2f f;
				f.position = mul(UNITY_MATRIX_MVP, v.vertex); // UNITY_MATRIX_MVP该矩阵用来把一个坐标从模型空间转换到剪裁空间
				
				// 法线方向。把法线方向从模型空间转换到世界空间
				fixed normalDir = normalize(mul(v.normal, (float3x3)_World2Object)); // 反过来相乘就是从模型到世界，否则是从世界到模型
				// 光照方向。
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz); // 对于每个顶点来说，光的位置就是光的方向，因为光是平行光
				// 漫反射Diffuse颜色 = 直射光颜色 * max（0，cos（光源方向 点乘 法线方向））
				fixed3 diffuse = _LightColor0 * max(0, dot(normalDir, lightDir));
				f.color = diffuse;

				return f;
			}

			// 计算每个像素点的颜色值
			fixed4 frag(v2f f) : SV_Target 
			{
				return fixed4(f.color, 1); // f.color是float3已经包含了三个数值
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
