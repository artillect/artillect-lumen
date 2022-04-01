#version 120

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec4 Color;
varying mat3 TBN;

// The texture atlas
uniform sampler2D texture;
uniform sampler2D normals;
uniform vec3 skyColor;
uniform vec3 fogColor;

void main(){
    // Sample from texture atlas and account for biome color + ambient occlusion
    vec4 Albedo = texture2D(texture, TexCoords) * Color;
    vec4 normal_tex = texture2D(normals, TexCoords);

    vec3 Normal;
    Normal.xy = normal_tex.xy * 2.0 - 1.0;
    Normal.z = sqrt(1.0-dot(Normal.xy, Normal.xy));
    Normal = normalize(TBN * Normal);
    Normal = Normal * 0.5 + 0.5;

    // Do fog calculations
    float fog = clamp((gl_FogFragCoord - gl_Fog.start * .6) * gl_Fog.scale, 0.0, 1.0);
    //float fog = clamp(1.0 - exp(-gl_FogFragCoord * 0.01), 0.0, 1.0);
    Albedo.rgb = mix(Albedo.rgb, fogColor, fog * 1.0);
    //Normal.xyz = mix(Normal.xyz, vec3(0.5), fog * 1.9);
    vec2 FogLightmap = LightmapCoords;
    FogLightmap = mix(LightmapCoords, vec2(0.0), fog * fog);
    /* DRAWBUFFERS:012 */
    // Write the values to the color textures
    gl_FragData[0] = Albedo;
    gl_FragData[1] = vec4(Normal, 1.0f);
    gl_FragData[2] = vec4(FogLightmap, 0.0f, 1.0f);
}