Shader "Unlit/Logo"
{
	Properties
	{
		_Value("Value",Range(0.0,1)) = 0.1
		_Color("Color",COLOR) = (0,0,0,0)
		_MainTex("Texture", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
	}
		SubShader
	{

		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		LOD 100

		Pass
		{
			Blend SrcAlpha Oneminussrcalpha
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _MaskTex;
			float4 _MaskTex_ST;
			float _Power;
			float _Value;

			float random(float2 st)
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
				return lerp(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;

			}

			float fbm(float2 p)
			{
				float result = 0.0;
				float amplitude = 1.0;

				for (int i = 0; i < 5; i++)
				{
					result += amplitude *abs( noise(p));
					amplitude *= 0.5;
					p *= 2.;
				}
				return result;
			}

			float box(float2 st, float size)
			{
				size = 0.5 + size * 0.5;
				st = step(st, size)*step(1.0 - st, size);
				return st.x*st.y;
			}

			float box_size(float2 st, float n)
			{
				st = (floor(st*n) + 0.5) / n;
				float offs = random(st) * 5;
				return (1 + sin(_Time.y * 3 + offs))*0.5;
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = _Color;
				float2 st = i.uv*2.0 - 1.0;
				float2 p = i.uv;

				p.x += noise(p*_Time.y)*_Value;
				fixed4 mask = tex2D(_MaskTex,p);

				col.a = 1 - mask.r;

				float2 q = float2(0.,0);
				q.x = fbm(st + float2(0.,0));
				q.y = fbm(st + float2(1.,0));

				float2 r = float2(0.,0.);

				r.x = fbm(st + (4.*q) + float2(1.9, 9.2) + (0.2*_Time));
				r.y = fbm(st + (4.*q) + float2(8.3, 2.8) + (0.2*_Time));

				float f = fbm(st + 4.*r);

				float3 color = lerp(float3(1.,0.,0.5),float3(0.,0.,1.0),f);
				return col * f;

		}

		ENDCG
	}

	}

}
