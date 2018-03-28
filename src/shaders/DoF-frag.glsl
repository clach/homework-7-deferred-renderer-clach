#version 300 es
#define PI 3.1415962
#define E 2.71828
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_frame2;

uniform float u_Time;

uniform vec4 u_CamPos; 

uniform mat4 u_View;
uniform mat4 u_Proj;

uniform vec2 u_Dimensions; 

/* Choose a "focal length" for your virtual camera and compare the camera-space 
	Z coordinate of your fragments to that distance. The farther the Z coordinate 
	is from that length, the stronger a blur effect you should apply to that fragment. 
	We recommend using a Gaussian blur for best visual results, but you are free to
	implement any blur you want.
*/

float gaussianEquation1D(float x, float sigma) {
	return (1.0 / (sqrt(2.0 * PI) * sigma)) * pow(E, -(x * x) / (2.0 * sigma * sigma));
}

void main() {
	//vec3 color = texture(u_frame, fs_UV).xyz;

	// let's do...depth of field
	float focalLength = 0.2; // focal length of camera

	float depth = texture(u_frame2, fs_UV).w;
	float distToCamera = abs(depth - focalLength);

	float sigma = distToCamera; // sigma ranges from 0 to 1
	sigma *= 1.0;

	const int kernelSize = 5; // must be odd
	int halfSize = (kernelSize - 1) / 2 + 1;

	float kernel[kernelSize];

	// fill in kernel using 1D gaussian equation
	for (int i = 0; i < halfSize; i++) {
		kernel[i] = gaussianEquation1D(float(i), sigma);
		kernel[kernelSize - 1 - i] = gaussianEquation1D(float(i), sigma);
	}

	float divisor = 0.0;
	for (int j = 0; j < kernelSize; ++j) {
		divisor += kernel[j];
	}

	vec3 color = vec3(0.0);

	// apply blur
	// using 1D kernels but applying both at once
	// I tried doing just horizontal then just vertical but it had artifacts (looked boxy?)
	for (int i = -halfSize + 1; i < halfSize; i++) { // horizontal blur
		for (int j = -halfSize + 1; j < halfSize; j++) { // vertical blur 
			vec3 pixelColor = texture(u_frame, fs_UV + vec2(float(i), float(j)) / u_Dimensions.xy).rgb;
			color += kernel[i + halfSize - 1] * kernel[j + halfSize - 1] * pixelColor;
		}
	}

	out_Col = vec4(color / (divisor * divisor), 1.0);
	out_Col = vec4(depth, depth, depth, 1.0);
}
