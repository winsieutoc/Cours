uniform sampler2D colorMap;

// center of lens for un-distortion (in normalized coordinates between 0 and 1)
uniform vec2 centerCoordinate;

// lens distortion parameters
uniform vec2 K;

// texture coordinates
varying vec2 vUv;

void main() {
	// TODO
	float r = sqrt((vUv.x-centerCoordinate.x)*(vUv.x-centerCoordinate.x)+(vUv.y-centerCoordinate.y)*(vUv.y-centerCoordinate.y));
	float xd = (vUv.x - centerCoordinate.x)*(1.0 + K.x*r*r + K.y*r*r*r*r) + centerCoordinate.x;
	float yd = (vUv.y - centerCoordinate.y)*(1.0 + K.x*r*r + K.y*r*r*r*r) + centerCoordinate.y;
	vec2 res = vec2(xd,yd);

	if(xd>=0.0 && xd<=1.0 && yd>=0.0 && yd<=1.0){
		gl_FragColor = texture2D(colorMap, res);
	}else{
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	}
}
