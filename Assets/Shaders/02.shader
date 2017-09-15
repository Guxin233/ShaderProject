Shader "Custom/02" {
	SubShader{
		Pass {
			CGPROGRAM

#pragma vertex vert
			// 计算顶点坐标从模型坐标系转换到裁剪面坐标系
			float4 vert(float4 v : POSITION) : SV_POSITION // POSITION语意表示让系统把顶点坐标传递给参数v，SV_POSITION语意表示该float4类型的返回值是剪裁空间的顶点坐标
			{
				return mul(UNITY_MATRIX_MVP, v);
			}

#pragma fragment frag
			// 计算每个像素点的颜色值
			fixed4 frag() : SV_Target 
			{
				return fixed4(0.5,0.5,1,1);
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
