#version 150

//  Trim detection adapted from Emissive Trims by Bluebird (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

float hash(vec2 p) { return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453); }
float asymWarp(float t, float r) { return t < r ? 0.5 * t / r : 0.5 + 0.5 * (t - r) / (1.0 - r); }

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) { discard; }

    ivec2 texSize = textureSize(Sampler0, 0);
    vec2 texSizeF = vec2(texSize);
    bool isTrim = (texSize.x == 2048 || texSize.x == 1024) && mod(texSizeF.y, 1024.0) == 0.0;

    if (isTrim) {
        float lightLevel = max(max(vertexColor.r, vertexColor.g), vertexColor.b);
        float time = GameTime;
        float cycle = 0.0000000;
        if (cycle > 0.0) time = mod(GameTime, cycle);
        float jitter = 0.0000000;
        float j = jitter > 0.0 ? hash(texCoord0) * jitter : 0.0;
        float angle = (time + j) * 7600.0 + 0.0 * 0.0000000;
        float phase = fract(angle / 6.283185307);
        float warped = phase;
        float chroma = 0.0000000;
        float warpedG = chroma > 0.0 ? fract(warped + chroma * 0.0000000) : warped;
        float warpedB = chroma > 0.0 ? fract(warped + chroma * 0.0000000) : warped;
        float rawPulseR = 0.5 + 0.5 * sin(warped * 6.283185307);
        float rawPulseG = chroma > 0.0 ? 0.5 + 0.5 * sin(warpedG * 6.283185307) : rawPulseR;
        float rawPulseB = chroma > 0.0 ? 0.5 + 0.5 * sin(warpedB * 6.283185307) : rawPulseR;
        float pulseR = pow(rawPulseR, 2.2);
        float pulseG = pow(rawPulseG, 2.2);
        float pulseB = pow(rawPulseB, 2.2);
        float ri = 0.0000000; if (ri > 0.0 && cycle > 0.0 && time < ri) { float s = smoothstep(0.0, ri, time); pulseR *= s; pulseG *= s; pulseB *= s; }
        float ro = 0.0000000; if (ro > 0.0 && cycle > 0.0 && time > cycle - ro) { float s = 1.0 - smoothstep(cycle - ro, cycle, time); pulseR *= s; pulseG *= s; pulseB *= s; }
        if (0 > 0) {
            float pause = 0.0000000; float fade = 0.0000000;
            float segLen = cycle > 0.0 ? cycle / float(0) : 1.0 / 1.0000000;
            float segT = cycle > 0.0 ? mod(time, segLen) / segLen : fract(time * 1.0000000);
            float gate = smoothstep(0.0, fade, segT) * (1.0 - smoothstep(1.0 - fade - pause, 1.0, segT));
            pulseR *= gate; pulseG *= gate; pulseB *= gate;
        }
        float dualA = 0.0000000;
        if (dualA > 0.0) {
            float dMod = 1.0 + dualA * (0.5 + 0.5 * sin((time + j) * 0.0 * 6.283185307));
            pulseR *= dMod; pulseG *= dMod; pulseB *= dMod;
        }
        float eLight = 0.0000000;
        float eMod = 1.0 - eLight * (1.0 - lightLevel);
        pulseR *= max(0.0, eMod); pulseG *= max(0.0, eMod); pulseB *= max(0.0, eMod);
        float pNoise = 0.0000000;
        if (pNoise > 0.0) {
            float nv = pNoise * (hash(texCoord0 + fract(time * 0.1000000)) - 0.5);
            pulseR = clamp(pulseR + nv, 0.0, 1.0);
            pulseG = clamp(pulseG + nv, 0.0, 1.0);
            pulseB = clamp(pulseB + nv, 0.0, 1.0);
        }
        float df = 0.0000000;
        vec4 litColor = df > 0.0 ? max(color * vertexColor, color * df) : color * vertexColor;
        vec4 brightColor = vec4(color.rgb * vec3(1.0, 1.0, 1.0) * 1.4, color.a);
        float sat = 1.0000000;
        if (sat != 1.0) {
            vec3 gray = vec3(dot(brightColor.rgb, vec3(0.299, 0.587, 0.114)));
            brightColor.rgb = mix(gray, brightColor.rgb, sat);
        }
        float hue = 0.0000000;
        if (hue != 0.0) {
            float ha = hue * 0.017453292;
            float c = cos(ha), s = sin(ha);
            brightColor.rgb *= mat3(
                vec3(0.299+0.701*c+0.168*s, 0.587-0.587*c+0.330*s, 0.114-0.114*c-0.497*s),
                vec3(0.299-0.299*c-0.328*s, 0.587+0.413*c+0.035*s, 0.114-0.114*c+0.292*s),
                vec3(0.299-0.300*c+1.250*s, 0.587-0.588*c-1.050*s, 0.114+0.886*c-0.203*s)
            );
        }
        color.r = mix(litColor.r, brightColor.r, pulseR);
        color.g = mix(litColor.g, brightColor.g, pulseG);
        color.b = mix(litColor.b, brightColor.b, pulseB);
    } else {
        color *= vertexColor;
    }

    color *= ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
