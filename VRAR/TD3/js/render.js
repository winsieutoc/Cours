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
  renderer.clear();
  renderer.render(scene, camera);

  stats.update();
}
