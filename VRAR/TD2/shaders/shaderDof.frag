uniform mat4 projectionMatrix2;
uniform mat4 inverseProjectionMatrix;

uniform float focusDistance;
uniform float pupilDiameter;
uniform float pixelPitch;

uniform vec2 gazePos;

uniform sampler2D colorMap;
uniform sampler2D depthMap;
uniform vec2 textureSize;

varying vec2 vUv;

// TODO: distance to camera computation
float distToFrag( float z_buffer ) {
	return projectionMatrix2[3][2] * 1/(z_buffer-projectionMatrix2[2][2]);
}

// TODO: circle of confusion computation
float computeCoC( float fragDist, float focusDist ) {
	float s = foccusDistance + fragDist;
	float b = abs(s-focusDist)*pupilDiameter/s;
	return b/pixelPitch/2;
}

// TODO: adaptive blur computation
vec4 computeBlur( float radius ) {

}

void main() {
	gl_FragColor = texture2D( colorMap, vUv );
}
