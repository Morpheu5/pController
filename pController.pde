float fps;
ParticleController particleController;

void setup() {
  fps = 30.0f;
  size(800, 600);
  frameRate(fps);
  colorMode(HSB, 360, 100, 100);
  
  particleController = new ParticleController(1000);
}

void update() {
  particleController.update();
}

void draw() {
  update();
  
  background(0, 0, 0);
  particleController.draw();
}
