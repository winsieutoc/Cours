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
	return projectionMatrix2[3][2] * (1.0/(z_buffer + projectionMatrix2[2][2]));
}

// TODO: circle of confusion computation
float computeCoC( float fragDist, float focusDist ) {
	float s1 = focusDist;
	float s = fragDist;
	float d = pupilDiameter;
	float b = (d*(abs(s-s1)))/s;
	return b/(2.0*pixelPitch);
}

// TODO: adaptive blur computation
vec4 computeBlur( float radius ) {
	vec4 res = vec4(0.0);
	float cpt = 0.0;
	for (float i=0.0; i<15.0; i++){
 		for (float j=0.0; j<15.0; j++){
 			if ((i*i+j*j) <= radius*radius){
				vec2 voisin = vec2(i/textureSize.x, j/textureSize.y);
				res += texture2D(colorMap, vUv+voisin);
				cpt +=1.0;
			}
		}
	}
	return res/cpt;
}

void main() {
	//gl_FragColor = texture2D( colorMap, vUv );
	float zNDC = 2.0*texture2D(depthMap, vUv).x -1.0;
	float zNDC2 = 2.0*texture2D(depthMap, vec2(0.5,0.5)).x -1.0;
	float fragDist = distToFrag(zNDC);
	float fragDist2 = distToFrag(zNDC2);
	float blurRadius = computeCoC(fragDist2, fragDist);
	vec4 blur = computeBlur(blurRadius);
	gl_FragColor = blur;
}
