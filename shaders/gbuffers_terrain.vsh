#version 120

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec4 Color;
varying mat3 TBN;

attribute vec3 vaNormal;
attribute vec4 at_tangent;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;


void main() {
    // Transform the vertex
    gl_Position = ftransform();

    vec3 pos        = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos             = (gbufferModelViewInverse * vec4(pos, 1.0)).xyz;
    gl_FogFragCoord = length(pos);
    
    // Create TBN matrix
    vec3 tangent_vec = normalize(vec3(gbufferModelView * at_tangent));
    vec3 normal_vec = normalize(vec3(gbufferModelView * vec4(vaNormal, 0.0)));
    vec3 binormal_vec = cross(tangent_vec, normal_vec);
    TBN = mat3(tangent_vec, binormal_vec, normal_vec);
    
    // Assign values to varying variables
    TexCoords = gl_MultiTexCoord0.st;
    // Use the texture matrix instead of dividing by 15 to maintain compatiblity for each version of Minecraft
    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    // Transform them into the [0, 1] range
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    //Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
}