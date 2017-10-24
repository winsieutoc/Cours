function AnaglyphRenderer ( renderer ) {

  // left and right cameras
  this.cameraLeft  = new THREE.Camera();
  this.cameraLeft.matrixAutoUpdate = false;
  this.cameraRight = new THREE.Camera();
  this.cameraRight.matrixAutoUpdate = false;

  var ipd = displayParameters.ipd;
  var h = 285.75;
  var w = 508;
  var d = displayParameters.distanceScreenViewer;

	this.update = function ( camera ) {

    var znear = camera.near;
    var zfar = camera.far;
    var left = -znear*((w-ipd)/(2*d));
    var right = znear*((w+ipd)/(2*d));
    var top = znear*(h/(2*d));
    var bottom = -znear*(h/(2*d));

    camera.updateMatrixWorld();
    this.cameraLeft.matrixWorld = camera.matrixWorld.clone();
    this.cameraRight.matrixWorld = camera.matrixWorld.clone();
    this.cameraLeft.translateX(ipd/2);
    this.cameraRight.translateX(-ipd/2);

    var projectionCamLeft = new THREE.Matrix4().makePerspective( left, right, top, bottom, znear, zfar );
    var projectionCamRight = new THREE.Matrix4().makePerspective( -right, -left, top, bottom, znear, zfar );

    this.cameraLeft.projectionMatrix = projectionCamLeft;
    this.cameraRight.projectionMatrix = projectionCamRight;

	}

  this.render = function ( scene, camera ) {

    var gl = renderer.domElement.getContext( 'webgl' );
    gl.colorMask(true,false,false,false);
    this.update(camera);
    renderer.render(scene, this.cameraLeft);
    renderer.clearDepth();
    gl.colorMask(false,true,true,false);
    renderer.render(scene, this.cameraRight);

  }

}
