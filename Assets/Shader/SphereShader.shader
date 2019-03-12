Shader "Unlit/SphereShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Power("Power",Float) = 1
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Power;

			#define OCTAVES 5
			#define CS(a) float2(cos(a),sin(a))


			const float PI = 3.14;
			const float angle = 90.0;


			float3 trans(float3 p)
			{
				return fmod(p, 4.0) - 2.0;
			}

			float random(in float2 st)
			{
				return frac(sin(dot(st.xy, float2(12.443, 78.4)))*43758.2);
			}

			float distanceFunc(float3 p)
			{
				return length(p)-1.0;
				//return length(p) - (1.0 + sin((p.y +  _Power) * 10.0) * 0.1);
			}

			//normal info
			float3 getNormal(float3 p)
			{
				float d = 0.01;
				return normalize(float3(
					distanceFunc(p + float3(d, 0.0, 0.0)) - distanceFunc(p + float3(-d, 0.0, 0.0)),
					distanceFunc(p + float3(0.0, d, 0.0)) - distanceFunc(p + float3(0.0, -d, 0.0)),
					distanceFunc(p + float3(0.0, 0.0, d)) - distanceFunc(p + float3(0, 0.0, -d))
				));
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
				const float fov = 90.0 * 0.5 * 3.14 / 180.0;
				float2 p = i.uv*2.0 - 1.0;
				p.x += sin(p.y * 10 + _Time.y) * _Power;
				float3 cPos = float3(0.0, 0.0, 2.0);
				float3 cDir = float3(0.0, 0.0, -1.0);
				float3 cUp = float3(0.0, 1.0, 0.0);
				float3 cSide = cross(cDir, cUp);
				float targetDepth = 1.0;

				float3 ray = normalize(float3(sin(fov)*p.x, sin(fov)*p.y, -cos(fov)));

				float dist = 0.0;
				float rlen = 0.0;
				float3 rPos = cPos;

				for (int i = 0; i < 64; i++)
				{
					dist = distanceFunc(rPos);

					rlen += dist;
					rPos = cPos + ray * rlen;
				}

				float3 lightDir = float3(-0.577, 0.577, 0.577);
				if (abs(dist) < 0.001)
				{
					float3 nor = getNormal(rPos);
					float diff = clamp(dot(nor, lightDir), 0.1, 1.0);
					return float4(nor, 1.0);
				}
				else
				{
					 return float4(0,0,0,0.0);
				}
			}

			ENDCG
		}
	}
}
