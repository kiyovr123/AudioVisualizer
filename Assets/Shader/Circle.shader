Shader "Unlit/Circle"
{
	Properties
	{
		_Power("Power",Float) = 0
		_Scale("Sclae",Float) = 0
		_ColorA("ColorA",COLOR) = (0,0,0,0)
		_ColorB("ColorB",COLOR) = (0,0,0,0)
		_ColorC("ColorC",COLOR) = (0,0,0,0)
		_Thick("Thick",Float) = 0.005
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float _Power;
			float _Scale;
			float4 _ColorA;
			float4 _ColorB;
			float4 _ColorC;
			float _Thick;

			float random(in float2 st)
			{
				return frac(sin(dot(st.xy, float2(12.443, 78.4)))*43758.2);
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
				return lerp(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
			}

			float circle(float2 st,float scale)
			{
				float f = 0;
				f += _Thick / abs(length(st / scale) - 0.5);
				return f;
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 st = i.uv * 2.0 - 1.0;
				st.x += sin(st.y * 20 + _Time.y) * _Power;

				float a = circle(st,_Scale);
				float b = circle(st,_Scale*1.3);
				float c = circle(st, _Scale*1.6);

				float4 f = lerp(a*_ColorA,b*_ColorB,0.5);
				float4 col = lerp(f,c*_ColorC,0.5);
				return col;
			}
			ENDCG
		}
	}
}
