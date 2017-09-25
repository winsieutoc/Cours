var container, stats, scene, camera, renderer, geometry;
var material1, material2, material3, materiel4, material5, materials, tnt1, tnt2, stone, sand, stoneM;
var cube, group1, group2, controls, clock;
var z, q, s, d;

function getRandomArbitrary(min, max) {
  return Math.random() * (max - min) + min;
}

function init() {

  container = document.createElement( 'div' );
  document.body.appendChild( container );

  // stats

  stats = new Stats();
  container.appendChild( stats.dom );

  scene = new THREE.Scene();
  clock = new THREE.Clock();
  camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000);

  renderer = new THREE.WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  tnt1 = new THREE.TextureLoader().load('textures/tnt1.png');
  material1 = new THREE.MeshBasicMaterial( { map: tnt1 } );

  tnt2 = new THREE.TextureLoader().load('textures/tnt2.png');
  material2 = new THREE.MeshBasicMaterial( { map: tnt2 } );

  stone = new THREE.TextureLoader().load('textures/stonebrick.png');
  material3 = new THREE.MeshBasicMaterial( { map: stone } );

  sand = new THREE.TextureLoader().load('textures/sand.png');
  material4 = new THREE.MeshBasicMaterial( { map: sand } );

  stoneM = new THREE.TextureLoader().load('textures/stonebrick_mossy.png');
  material5 = new THREE.MeshBasicMaterial( { map: stoneM } );

  geometry = new THREE.BoxGeometry( 1, 1, 1 );

  materials = [material1, material1, material2, material2, material1, material1];
  cube = new THREE.Mesh( geometry, materials );


  group1 = new THREE.Group();
  for(var i=-10; i<11; i++){
    for(var j=-10; j<11; j++){
      var random = getRandomArbitrary(0, 100);
      if(random < 60){
        var arena1 = new THREE.Mesh( geometry, material3);
      }
      else{
        var arena1 = new THREE.Mesh( geometry, material5);
      }
      arena1.position.x = i;
      arena1.position.y = -1;
      arena1.position.z = j;
      group1.add( arena1 );
    }
  }

  group2 = new THREE.Group();
  for(var i=-10; i<11; i++){
    for(var j=-10; j<11; j++){
      var arena2 = new THREE.Mesh( geometry, material4);
      arena2.position.x = i;
      arena2.position.y = -2;
      arena2.position.z = j;
      group2.add( arena2 );
    }
  }

  scene.add( cube );
  scene.add ( group1 );
  scene.add ( group2 );


  camera.position.z = 5;

  controls = new THREE.PointerLockControls( camera, renderer.domElement );
  controls.enabled = true;
  scene.add( controls.getObject() );
  controls.addEventListener("z",

}


function animate() {

  requestAnimationFrame( animate );
	renderer.render( scene, camera );
  //controls.update(clock.getDelta());
  controls.addEventListener("keydown", camare.postion)
  stats.update();

}
