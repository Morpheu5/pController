/**
 * A class representing a particle through a number of manipulable properties.
 */
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float decay;
  float radius;
  color colour;
  
  /**
   * Class costructor setting some sensible default values.
   */
  Particle() {
    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    radius = random(1);
    decay = map(radius, 0, 1, 0.9, 0.95);
    colour = color(random(360), random(100), random(100));
  }
  
  /**
   * This is where the magic happens, i.e. the particle changes its own location
   * according to its parameters.
   */
  void update() {
    velocity.add(acceleration);
    
    float maxVelocity = radius + 0.0025f;
    float speed = velocity.mag()*velocity.mag() + 0.1;
    if(speed > maxVelocity*maxVelocity) {
      velocity.normalize();
      velocity.mult(maxVelocity);
    }
    
    position.add(velocity);
    velocity.mult(decay);
    acceleration.set(new PVector(0, 0));
  }
  
  /**
   * This is how the particle is drawn on screen.
   */
  void draw() {
    noStroke();
    fill(colour);
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}
