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
    // Do fog calculations
    float fog = clamp(pow(gl_FogFragCoord - gl_Fog.start * 1.0, 1.0) * gl_Fog.scale * 0.5, 0.0, 1.0);

    vec3 Normal;
    Normal.xy = normal_tex.xy * 2.0 - 1.0;
    Normal.z = sqrt(1.0-dot(Normal.xy, Normal.xy));
    Normal = normalize(TBN * Normal);
    Normal = Normal * 0.5 + 0.5;

    /* DRAWBUFFERS:0123 */
    // Write the values to the color textures
    gl_FragData[0] = Albedo;
    gl_FragData[1] = vec4(Normal, 1.0f);
    gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(fog, 1.0f, 0.0f, 1.0f);
}