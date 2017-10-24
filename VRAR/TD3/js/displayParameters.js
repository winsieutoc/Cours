var displayParameters = {

  // parameters for stereo rendering
  // physical screen diagonal -- in mm
  screenDiagonal: 337.82,
  screenResolutionWidth: 2560,
  aspectRatio: 1.6,

  // inter pupillar distance -- in mm
  ipd: 64,

  // distance bewteen the viewer and the screen -- in mm
  distanceScreenViewer: 500,

  // TODO: amount of distance in mm between adjacent pixels
  pixelPitch: function() {
    return this.screenDiagonal/Math.sqrt(Math.pow(this.screenResolutionWidth,2) + Math.pow((this.screenResolutionWidth/this.aspectRatio),2));
  },

  //TODO: physical display width and height -- in mm
  screenSize: function() {
    return new THREE.Vector2(this.screenResolutionWidth*this.pixelPitch(),(this.screenResolutionWidth/this.aspectRatio)*this.pixelPitch());
  }

};
