#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_frame2;

uniform float u_Time;

uniform vec2 u_Dimensions;


void main() {
	vec3 color = vec3(texture(u_frame, fs_UV.xy));
	float luminance = 0.21 * color.r + 0.72 * color.g + 0.07 * color.b;

	float overlapsMesh = vec3(texture(u_frame2, fs_UV.xy)).x;

	color = vec3(1.0, 1.0, 1.0);

	if (mod(gl_FragCoord.y, 20.0) < 2.0) {
		color = vec3(0.0, 0.0, 1.0);
	}
	if (gl_FragCoord.x < 70.0 && gl_FragCoord.x > 68.0) {
		color = vec3(1.0, 0.0, 0.0);
	}

	if (overlapsMesh == 1.0) {
		if (luminance < 1.00) {
			if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) >= 0.0 && 
				mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) <= 1.0) {
				color = vec3(0.0, 0.0, 0.0);
			}
		}
		if (luminance < 0.75) {
			if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) >= 0.0 &&
				mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) <= 1.0) {
				color = vec3(0.0, 0.0, 0.0);
			}
		}
		if (luminance < 0.50) {
			if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) >= 0.0 && 
				mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) <= 1.0 ) {
				color = vec3(0.0, 0.0, 0.0);
			}
		}

		if (luminance < 0.3465) {
			if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) >= 0.0 && 
				mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) <= 1.0) {
				color = vec3(0.0, 0.0, 0.0);
			}
		}
	}


 	out_Col = vec4(color, 1.0);

	//out_Col = vec4(gl_FragCoord.y / u_Dimensions.y, 0.0, 0.0, 1.0);
}
