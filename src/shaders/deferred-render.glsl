#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
uniform sampler2D u_gb2;


uniform float u_Time;

uniform mat4 u_View;
uniform mat4 u_Proj;

uniform vec4 u_CamPos;   


void main() { 
	vec3 lightPos = vec3(5.0, 5.0, 5.0); // //vec3 lightPos = vec3(4.0 * sin(u_Time), 2.0, 4.0 * cos(u_Time));

	// read from GBuffers
	vec4 gb0 = texture(u_gb0, fs_UV);
	vec4 gb1 = texture(u_gb1, fs_UV);
	vec4 gb2 = texture(u_gb2, fs_UV);

	vec3 nor = normalize(gb0.xyz);

	// find worldspace X and Y
	// map UV to [-1, 1] NDC space
	vec2 ndcPos = fs_UV.xy * 2.0 - 1.0;
	vec4 worldspacePos = inverse(u_Proj * u_View) * vec4(fs_UV.x, fs_UV.y, gb0.w, 1.0);
	worldspacePos /= worldspacePos.w;

	vec3 lightVec = normalize(lightPos - worldspacePos.xyz);
	vec3 viewVec = normalize(u_CamPos.xyz - worldspacePos.xyz);
	vec3 H = (viewVec + lightVec) / 2.0;

	// let's do a Blinn-Phong
	vec3 diffuseCol = gb2.xyz; 
	vec3 specularCol = vec3(1.0, 1.0, 1.0);

	// diffuse and ambient terms
    float diffuseTerm = clamp(dot(nor, lightVec), 0.0, 1.0);
	float ambientTerm = 0.1;

    // blinn-phong term
	float shininess = 56.0;
    float specularTerm = max(pow(dot(H, nor), shininess), 0.0);

	vec3 col = diffuseCol * (diffuseTerm + ambientTerm) + specularCol * specularTerm;

    // Compute final shaded color
    out_Col = vec4(col, 1.0);

}