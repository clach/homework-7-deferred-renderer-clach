#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_frame2;
uniform float u_Time;

// bloom high pass
void main() {
    vec3 color = texture(u_frame, fs_UV).xyz;

    float luminance = 0.21 * color.r + 0.72 * color.g + 0.07 * color.b;

    float bg = texture(u_frame2, fs_UV).x;
    if (bg == 1.0) {
        if (luminance < 0.2) {
            color = vec3(0.0);
        } 
    }

    out_Col = vec4(color, 1.0);
}
