Shader "Unlit/Brick"
{
	Properties
	{
		_Power("Power",Float) = 1
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Power;

			float random(float2 st)
			{
				return frac(sin(dot(st.xy, float2(12.443, 78.4)))*43758.2);
			}

			float box(float2 st, float size)
			{
				size = 0.5 + size * 0.5;
				st = step(st, size)*step(1.0 - st , size);
				return st.x*st.y;
			}

			float box_size(float2 st,float n)
			{
				st = (floor(st*n) + 0.5) / n;
				float offs = random(st) * 5 * _Power;
				return (1 + sin(_Time.y * 3 + offs))*0.5;
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 st = i.uv*2.0 - 1.0;
				float n = 4;
				float2 fst = frac(st*n);

				float size = box_size(st,n);
				return box(fst,size);
			}
			ENDCG
		}
	}
}
