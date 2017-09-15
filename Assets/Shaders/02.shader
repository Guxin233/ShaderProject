Shader "Custom/02" {
	SubShader{
		Pass {
			CGPROGRAM

#pragma vertex vert
			float4 vert(float4 v : POSITION) : SV_POSITION // 计算模型坐标到裁剪面坐标
			{
				return mul(UNITY_MATRIX_MVP, v);
			}

#pragma fragment frag
			fixed4 frag() : SV_Target // 计算每个像素点的颜色值
			{
				return fixed4(0.5,0.5,1,1);
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
