var canvas, context, imageData, imageDst;
var red, green, blue, alpha, text;
var renderer;

var Menu = function() {
  this.threshold = false;
};

var menu, stats;

var FizzyText = function() {

  this.color = [ 0, 128, 255, 0.3 ]; // RGB with alpha
  this.color3 = { h: 350, s: 0.9, v: 0.3 }; // Hue, saturation, value

  this.tolerance = 30;

  // Define render logic ...

};


var camera, controls, scene, renderer;

var anaglyphRenderer, dofRenderer;

var container, stats;

var cameraOrtho, sceneOrtho;

var clock;

var moveForward = false;
var moveBackward = false;
var moveLeft = false;
var moveRight = false;

var pointerLocked = false;

var velocity = new THREE.Vector3(0,0,0);

function init() {

  canvas = document.getElementById("canvas");
  canvas.width = parseInt(canvas.style.width);
  canvas.height = parseInt(canvas.style.height);

clock = new THREE.Clock();

  context = canvas.getContext("2d");

container = document.createElement( 'div' );
  document.body.appendChild( container );

  imageDst = new ImageData( canvas.width, canvas.height)

  renderer = new THREE.WebGLRenderer();
  renderer.setSize(canvas.width, canvas.height);
  renderer.setClearColor(0xffffff, 1);
  document.getElementById("container").appendChild(renderer.domElement);

var fov = THREE.Math.radToDeg(Math.atan( displayParameters.screenSize().y/ displayParameters.distanceScreenViewer));
  camera = new THREE.PerspectiveCamera( fov, window.innerWidth / window.innerHeight, 1, 100000 );

  cameraOrtho = new THREE.OrthographicCamera( - window.innerWidth / 2, window.innerWidth / 2, window.innerHeight / 2, - window.innerHeight / 2, 1, 10 );
  cameraOrtho.position.z = 10;

  scene = new THREE.Scene();
  camera = new THREE.OrthographicCamera(-0.5, 0.5, 0.5, -0.5);
  scene.add(camera);
  texture = createTexture();
  scene.add(texture);

  // GUI
  menu = new Menu();
  text = new FizzyText();
  var gui = new dat.GUI();
  gui.add(menu, 'threshold');
  window.addEventListener( 'mousedown', getColor, false );
  gui.addColor(text, 'color').listen();
  gui.add(text, 'tolerance',0,255);

var geometry = new THREE.BoxGeometry( 100, 100, 100 );

  var tnt1 = new THREE.TextureLoader().load( 'textures/tnt1.png' );
  var tnt2 = new THREE.TextureLoader().load( 'textures/tnt2.png' );
  var sand = new THREE.TextureLoader().load( 'textures/sand.png' );
  var stonebrick = new THREE.TextureLoader().load( 'textures/stonebrick.png' );
  var stonebrick_mossy = new THREE.TextureLoader().load( 'textures/stonebrick_mossy.png' );

  var mat_tnt1 = new THREE.MeshBasicMaterial( { map: tnt1 } );
  var mat_tnt2 = new THREE.MeshBasicMaterial( { map: tnt2 } );
  var mat_sand = new THREE.MeshBasicMaterial( { map: sand } );
  var mat_stonebrick = new THREE.MeshBasicMaterial( { map: stonebrick } );
  var mat_stonebrick_mossy = new THREE.MeshBasicMaterial( { map: stonebrick_mossy } );

  var cube_tnt = new THREE.Mesh( geometry, [mat_tnt1, mat_tnt1, mat_tnt2, mat_tnt2, mat_tnt1, mat_tnt1] );
  cube_tnt.position.y = 100;
  cube_tnt.position.z = - displayParameters.distanceScreenViewer;
  var cube_sand = new THREE.Mesh( geometry, mat_sand );
  cube_sand.position.y = -100;
  var cube_stonebrick = new THREE.Mesh( geometry, mat_stonebrick );
  var cube_stonebrick_mossy = new THREE.Mesh( geometry, mat_stonebrick_mossy );

  var color = new THREE.Color();
  for (var j = -10; j < 10; j++) {
    for (var k = -10; k < 10; k++) {
      var cs = cube_sand.clone();
      var geom = new THREE.BoxGeometry( 100, 100, 100 );
      applyFaceColor( geom , cs.id );
      cs.geometry = geom;
      cs.position.x = j*100;
      cs.position.z = k*100 - displayParameters.distanceScreenViewer;
      scene.add( cs );

      var cm;
      if(Math.random() > 0.25) {
        cm = cube_stonebrick.clone();
      } else {
        cm = cube_stonebrick_mossy.clone();
      }
      var geom = new THREE.BoxGeometry( 100, 100, 100 );
      applyFaceColor( geom , cm.id );
      cm.geometry = geom;
      cm.position.x = j*100;
      cm.position.z = k*100 - displayParameters.distanceScreenViewer;
      scene.add( cm );
    }
  }

  applyFaceColor( cube_tnt.geometry , cube_tnt.id );
  scene.add( cube_tnt );

  // aim
  sceneOrtho = new THREE.Scene();
  var line_material = new THREE.LineBasicMaterial({ color: 0xffffff });
  var line_geometry = new THREE.Geometry();
  line_geometry.vertices.push(new THREE.Vector3(-20, 0, 1));
  line_geometry.vertices.push(new THREE.Vector3(20, 0, 1));
  var line = new THREE.Line(line_geometry, line_material);
  sceneOrtho.add(line);
  line_geometry = new THREE.Geometry();
  line_geometry.vertices.push(new THREE.Vector3(0, -20, 1));
  line_geometry.vertices.push(new THREE.Vector3(0, 20, 1));
  var line = new THREE.Line(line_geometry, line_material);
  sceneOrtho.add(line);

  // renderers
  renderer = new THREE.WebGLRenderer();
  renderer.setPixelRatio( window.devicePixelRatio );
  renderer.setSize( window.innerWidth, window.innerHeight );
  container.appendChild( renderer.domElement );
  renderer.autoClear = false;

  anaglyphRenderer = new AnaglyphRenderer( renderer );
  dofRenderer = new DoFRenderer( renderer );

  pickingTexture = new THREE.WebGLRenderTarget( window.innerWidth, window.innerHeight );
  pickingTexture.texture.minFilter = THREE.LinearFilter;

  // trackball

  // controls = new THREE.TrackballControls( camera, renderer.domElement );
  controls = new THREE.PointerLockControls( camera, renderer.domElement );
  scene.add( controls.getObject() );
  controls.enabled = true;

  var onKeyDown = function ( event ) {

    switch ( event.keyCode ) {

      case 38: // up
      case 87: // w
        moveForward = true;
        break;

      case 37: // left
      case 65: // a
        moveLeft = true; break;

      case 40: // down
      case 83: // s
        moveBackward = true;
        break;

      case 39: // right
      case 68: // d
        moveRight = true;
        break;

    }

  };

  var onKeyUp = function ( event ) {

    switch( event.keyCode ) {

      case 38: // up
      case 87: // w
        moveForward = false;
        break;

      case 37: // left
      case 65: // a
        moveLeft = false;
        break;

      case 40: // down
      case 83: // s
        moveBackward = false;
        break;

      case 39: // right
      case 68: // d
        moveRight = false;
        break;

    }

  };

  document.addEventListener( 'keydown', onKeyDown, false );
  document.addEventListener( 'keyup', onKeyUp, false );

  // stats
  stats = new Stats();
  document.getElementById("container").appendChild( stats.dom );
  window.addEventListener( 'resize', onWindowResize, false );
  window.addEventListener( 'mousedown', pick, false );

  animate();
}

function getColor(event){
  if(event.button === 0) {
    console.log (event.clientX + " " +event.clientY);
    var posX = event.clientX;
    var posY = event.clientY;
    imageData = context.getImageData(posX, posY, posX, posY);
    red = imageData.data[0];
    green = imageData.data[1];
    blue = imageData.data[2];
    alpha = imageData.data[3];
  }
}

function applyFaceColor( geom, color ) {
  geom.faces.forEach( function( f ) {
    f.color.setHex(color);
  } );

function createTexture() {
  var texture = new THREE.Texture(imageDst),
  object = new THREE.Object3D(),
  geometry = new THREE.PlaneGeometry(1.0, 1.0, 0.0),
  material = new THREE.MeshBasicMaterial( {map: texture, depthTest: false, depthWrite: false} ),
  mesh = new THREE.Mesh(geometry, material);

  texture.minFilter = THREE.NearestFilter;

  object.position.z = -1;

  object.add(mesh);

  return object;
}

function onWindowResize() {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

  cameraOrtho.left = - window.innerWidth / 2;
  cameraOrtho.right = window.innerWidth / 2;
  cameraOrtho.top = window.innerHeight / 2;
  cameraOrtho.bottom = - window.innerHeight / 2;
  cameraOrtho.updateProjectionMatrix();

  dofRenderer.setSize( window.innerWidth, window.innerHeight );

  render();
}

function animate() {

  requestAnimationFrame( animate );
  text.color = [red, green, blue, alpha];

  if (video.readyState === video.HAVE_ENOUGH_DATA){
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    imageData = context.getImageData(0, 0, canvas.width, canvas.height);

    var tmp = new CV.Image(canvas.width, canvas.height);
    var whitedata = [255,255,255,255];
    var blackdata = [0,0,0,0];
    var src = imageData.data, len = src.length;
    var imgDst = tmp.data;
    var binary = new CV.Image(canvas.width, canvas.height);
    if(menu.threshold){
      for (var i = 0; i < len; i+=4) {
        if(src[i]>text.color[0]-text.tolerance && src[i+1]>text.color[1]-text.tolerance && src[i+2]>text.color[2]-text.tolerance
        && src[i]<text.color[0]+text.tolerance && src[i+1]<text.color[1]+text.tolerance && src[i+2]<text.color[2]+text.tolerance){
          imageDst.data[i]=255.0;
          imageDst.data[i+1]=255.0;
          imageDst.data[i+2]=255.0;
          imgDst[i/4] = 255;
        }
        else {
          imageDst.data[i]=0.0;
          imageDst.data[i+1]=0.0;
          imageDst.data[i+2]=0.0;
          imgDst[i/4] = 0;
        }
      }

      var dist = 0.0;
      var barX, barY;
      var contours = CV.findContours(tmp,binary);
      for(var i=0; i<contours.length;i++){
        var sizePol =0.0;
        var x = 0.0;
        var y = 0.0;
        var Sumx=0.0;
        var Sumy=0.0; //pour la barycentre
        for(var j=0; j<contours[i].length;j++){
          Sumx+=contours[i][j].x;
          Sumy+=contours[i][j].y;
          sizePol++;
        }

        Sumx= Sumx/sizePol;
        Sumy= Sumy/sizePol;
        //coordonnée barycentrique
        for(var j=0; j<contours[i].length;j++){
          x = contours[i][j].x;
          y = contours[i][j].y;
          if (dist<Math.sqrt ((x-Sumx)*(x-Sumx) + (y-Sumy)*(y-Sumy))){
            dist  = Math.sqrt ((x-Sumx)*(x-Sumx) + (y-Sumy)*(y-Sumy));
            barX = Sumx;
            barY = Sumy;
          }
        }
      }

      context.beginPath();
      context.arc(barX,barY,dist,0,2*Math.PI);
      context.stroke();

    }
    else{
      imageDst.data.set(imageData.data);
    }
    texture.children[0].material.map.needsUpdate = true;
    render();
  }
}

function render() {

  var delta = clock.getDelta();

  velocity.x -= velocity.x * 10.0 * delta;
  velocity.z -= velocity.z * 10.0 * delta;

  if ( moveForward ) velocity.z -= 1500.0 * delta;
  if ( moveBackward ) velocity.z += 1500.0 * delta;

  if ( moveLeft ) velocity.x -= 1500.0 * delta;
  if ( moveRight ) velocity.x += 1500.0 * delta;

  controls.getObject().translateX( velocity.x * delta );
  controls.getObject().translateZ( velocity.z * delta );

  renderer.clear();
  renderer.render(scene, camera);
  //anaglyphRenderer.render(scene, camera);

  stats.update();
}
