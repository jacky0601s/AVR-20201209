// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

Shader "GoogleVR/ReticleJomo" {
    Properties{
      _Color1("Color in BG", Color) = (1, 1, 1, 1)
      _Color2("Color in FG", Color) = (1, 1, 1, 1)
      _InnerDiameter("InnerDiameter", Range(0, 10.0)) = 1.5
      _OuterDiameter("OuterDiameter", Range(0.00872665, 10.0)) = 2.0
      _DistanceInMeters("DistanceInMeters", Range(0.0, 100.0)) = 2.0
      _Ratio("Ratio", Range(0,1.0)) = 0.5
  }

  SubShader {
    Tags { "Queue"="Overlay" "IgnoreProjector"="True" "RenderType"="Transparent" }
    Pass {
      Blend SrcAlpha OneMinusSrcAlpha, OneMinusDstAlpha One
      AlphaTest Off
      Cull Back
      Lighting Off
      ZWrite Off
      ZTest Always

      Fog { Mode Off }
      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"

      uniform float4 _Color1;
      uniform float4 _Color2;
      uniform float _Ratio;
      uniform float _InnerDiameter;
      uniform float _OuterDiameter;
      uniform float _DistanceInMeters;

      struct vertexInput {
        float4 vertex : POSITION;
        float2 texcoord: TEXCOORD0;
      };

      struct fragmentInput{
          float4 position : SV_POSITION;
          float2 alpha : TEXCOORD3;
          float4 color : COLOR;
      };

      fragmentInput vert(vertexInput i) {
        float scale = lerp(_OuterDiameter, _InnerDiameter, i.vertex.z);

        float3 vert_out = float3(i.vertex.x * scale, i.vertex.y * scale, _DistanceInMeters);

        fragmentInput o;
        o.position = UnityObjectToClipPos (vert_out);
        if (i.texcoord.x >= _Ratio)
        {
            //o.alpha.x = 0;
            o.color = _Color1;
        }
        else
        {
            o.color = _Color2;
        }
        return o;
      }

      fixed4 frag(fragmentInput i) : SV_Target {
        fixed4 ret = i.color;
        //ret.a = i.alpha.x;
        return ret;
      }

      ENDCG
    }
  }
}
