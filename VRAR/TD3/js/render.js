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

  this.tolerance = 15;

  // Define render logic ...

};

function init() {

  canvas = document.getElementById("canvas");
  canvas.width = parseInt(canvas.style.width);
  canvas.height = parseInt(canvas.style.height);

  context = canvas.getContext("2d");

  imageDst = new ImageData( canvas.width, canvas.height)

  renderer = new THREE.WebGLRenderer();
  renderer.setSize(canvas.width, canvas.height);
  renderer.setClearColor(0xffffff, 1);
  document.getElementById("container").appendChild(renderer.domElement);
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
  gui.add(text, 'tolerance').listen();



  // stats
  stats = new Stats();
  document.getElementById("container").appendChild( stats.dom );

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

function animate() {

  requestAnimationFrame( animate );
  text.color = [red, green, blue, alpha];

  if (video.readyState === video.HAVE_ENOUGH_DATA){
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    imageData = context.getImageData(0, 0, canvas.width, canvas.height);

    var tmp = new CV.Image(canvas.width, canvas.height)
    var whitedata = [255,255,255,255];
    var blackdata = [0,0,0,0];
    var src = imageData.data, len = src.length;
    if(menu.threshold){
      for (var i = 0; i < len; i+=4) {
        if(src[i]>text.color[0]-text.tolerance && src[i+1]>text.color[1]-text.tolerance && src[i+2]>text.color[2]-text.tolerance
        && src[i]<text.color[0]+text.tolerance && src[i+1]<text.color[1]+text.tolerance && src[i+2]<text.color[2]+text.tolerance){
          imageDst.data[i]=255.0;
          imageDst.data[i+1]=255.0;
          imageDst.data[i+2]=255.0;
        }
        else {
          imageDst.data[i]=0.0;
          imageDst.data[i+1]=0.0;
          imageDst.data[i+2]=0.0;
        }
      }
    }
    else{
      imageDst.data.set(imageData.data);
    }
    texture.children[0].material.map.needsUpdate = true;
    render();
  }
}

function render() {
  renderer.clear();
  renderer.render(scene, camera);

  stats.update();
}
