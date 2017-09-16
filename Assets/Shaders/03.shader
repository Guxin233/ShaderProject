Shader "Custom/03" {
	SubShader{
		Pass {
			CGPROGRAM

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
				float3 temp : COLOR0; // 属性必须指定语意
			};

			// 计算顶点坐标从模型坐标系转换到裁剪面坐标系
			v2f vert(a2v v)
			{
				v2f f;
				f.position = mul(UNITY_MATRIX_MVP, v.vertex);
				f.temp = v.normal;
				return f;
			}

			// 计算每个像素点的颜色值
			fixed4 frag(v2f f) : SV_Target 
			{
				return fixed4(f.temp, 1); // f.temp是float3已经包含了三个数值
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
