Shader "Custom/02" {
	SubShader{
		Pass {
			CGPROGRAM

#pragma vertex vert
			// 由系统调用。计算顶点坐标从模型坐标系转换到裁剪面坐标系。每个顶点计算。
			float4 vert(float4 v : POSITION) : SV_POSITION // POSITION语意表示让系统把顶点坐标传递给参数v，SV_POSITION语意表示该float4类型的返回值是剪裁空间的顶点坐标
			{
				return mul(UNITY_MATRIX_MVP, v); // mul矩阵相乘函数。mul(UNITY_MATRIX_MVP, v)用于将任一点的位置从模型坐标转换为剪裁空间坐标
			}

#pragma fragment frag
			// 由系统调用。计算每个像素点的颜色值。模型对应在屏幕上的每个像素点都计算，因此调用次数多于vertex函数。
			fixed4 frag() : SV_Target 
			{
				return fixed4(0.5,0.5,1,1);
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
