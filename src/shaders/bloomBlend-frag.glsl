#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_frame2;

uniform float u_Time;


void main() {
	vec3 color = texture(u_frame, fs_UV).xyz;
	vec3 highPass = texture(u_frame2, fs_UV).xyz;

	out_Col = vec4(color + 1.2 * highPass, 1.0);
}
