#version 300 es
#define PI 3.1415962
#define E 2.71828
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;

uniform vec2 u_Dimensions;

float gaussianEquation1D(float x, float sigma) {
	return (1.0 / (sqrt(2.0 * PI) * sigma)) * pow(E, -(x * x) / (2.0 * sigma * sigma));
}

void main() {
	
	//vec3 color = texture(u_frame, fs_UV).xyz;

    const float sigma = 6.0;
	const int kernelSize = 2 * int(sigma) + 1; // must be odd
	const int halfSize = (kernelSize - 1) / 2 + 1;

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
			vec3 pixelColor = texture(u_frame, fs_UV + vec2(float(i), float(j) / u_Dimensions.xy)).rgb;
			color += kernel[i + halfSize - 1] * kernel[j + halfSize - 1] * pixelColor;
		}
	}

	out_Col = vec4(color / (divisor * divisor), 1.0);

}
