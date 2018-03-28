#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;


void main() {

 	// clamps the input color to the range [0, 1]
	vec3 color = texture(u_frame, fs_UV).xyz;
	color = min(vec3(1.0), color);

	color *= 16.0; // hard-coded exposure adjustment

	// linear:
	color = pow(color, vec3(1.0 / 2.2)); // gamma correction

	// reinhard
    //color = color / (1.0 + color);
	//color = pow(color, vec3(1.0 / 2.2)); // gamma correction

	// Jim Hejl and Richard Burgess-Dawson
	//vec3 x = vec3(max(color.x, 0.0), max(color.y, 0.0), max(color.z, 0.0));
    //color = (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);


	out_Col = vec4(color, 1.0);
}
