Shader "Unlit/LineTest"
{
	Properties
	{
		_Power("Power",Float) =1
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
				return frac(sin(dot(st.xy,float2(12.443,78.4)))*43758.2);
			}

			float noise(in float2 st)
			{
				float2 i = floor(st);
				float2 f = frac(st);
				float a = random(i);
				float b = random(i + float2(1.0, 0.0));
				float c = random(i + float2(0.0, 1.0));
				float d = random(i + float2(1.0, 1.0));

				float2 u = smoothstep(0.0, 1.0, f);
				return lerp(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;

			}

			float fbm(float2 p)
			{
				float result = 0.0;
				float amplitude = 1.0;

				for (int i = 0; i < 5; i++)
				{
					result += amplitude * noise(p);
					amplitude *= 0.5;
					p *= 2.;
				}
				return result;
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float plot(float2 st,float pct)
			{
				return smoothstep(pct - 0.02, pct, st.y) - smoothstep(pct, pct + 0.02 ,st.y);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 st = i.uv * 2.0 - 1.0;
				st.y += fbm(st + (4.) + float2(1.9, 9.2) + (0.15*_Time))*_Power;
				float y = 0.;
				float3 color = float3(y,y,y);
				float pct = plot(st,y);
				color = (1 - pct)*color + pct * float3(0,1,0);
				return pct;
			}
		ENDCG
	}
	}
}
