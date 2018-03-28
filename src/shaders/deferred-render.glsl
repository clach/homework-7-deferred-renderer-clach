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

uniform vec2 u_Dimensions;   

// noise function that returns vec2 in the range (-1, 1)
vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3))) ) * 43758.5453);
}

// returns value between -1 and 1
float rand(vec2 n) {
    return (fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453));
}

float interpNoise2D(float x, float y) {
    float intX = floor(x);
    float fractX = fract(x);
    float intY = floor(y);
    float fractY = fract(y);

    float v1 = rand(vec2(intX, intY));
    float v2 = rand(vec2(intX + 1.0, intY));
    float v3 = rand(vec2(intX, intY + 1.0));
    float v4 = rand(vec2(intX + 1.0, intY + 1.0));

    float i1 = mix(v1, v2, fractX);
    float i2 = mix(v3, v4, fractX);

    return mix(i1, i2, fractY);
}

// returns float from 0 to 2
float fbm(float x, float y) {
    float total = 0.0;
    float persistence = 0.7;
    int octaves = 8;

    for (int i = 0; i < octaves; i++) {
        float freq = pow(2.0, float(i));
        float amp = pow(persistence, float(i));

        total += interpNoise2D(x * freq, y * freq) * amp;
    }

    return total;
}


void main() { 
	vec3 lightPos = vec3(5.0, 5.0, 5.0); // //vec3 lightPos = vec3(4.0 * sin(u_Time), 2.0, 4.0 * cos(u_Time));

	// read from GBuffers
	vec4 gb0 = texture(u_gb0, fs_UV);
	vec4 gb1 = texture(u_gb1, fs_UV);
	vec4 gb2 = texture(u_gb2, fs_UV);

	// map UV to [-1, 1] NDC space
	vec2 ndcPos = fs_UV.xy * 2.0 - 1.0;

	vec3 color = vec3(0.53, 0.85, 0.95); // sky color

	//float fbmResult = fbm(ndcPos.x, ndcPos.y);
		//fbmResult /= 100.0;
	
		//color += vec3(fbmResult, fbmResult, fbmResult);

		//out_Col = vec4(0.53, 0.85, 0.95, 1.0);

		//out_Col = vec4(1.0, 0.0, 0.0, 1.0);


		vec3 nor = normalize(gb0.xyz);

		// find worldspace X and Y
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

		color = diffuseCol * (diffuseTerm + ambientTerm) + specularCol * specularTerm;
	

	out_Col = vec4(color, 1.0);

}