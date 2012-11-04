/**
 * A particle controller, also known as a particle engine.
 *
 * This controller is responsible for managing a number of particles and their
 * properties according to their surrounding environment.
 */
class ParticleController {
  /** The local pool of particles that are managed by this controller. */
  ArrayList particles;
  float minRadius;
  /**
   * This sets the upper limit for the range of radii. It's a property of
   * the controller since it's used in several places.
   */
  float maxRadius;
  
  /**
   * The constructor takes an integer setting the number of particles this
   * controller will manage.
   */
  ParticleController(int quantity) {
    // Always remember to initialize the non-primitive data types. 
    particles = new ArrayList();
    minRadius = 1;
    maxRadius = 20;
    
    // Here we create the particles in the pool and configure them a bit.
    for(int i = 0; i < quantity; i++) {
      Particle p = new Particle();
      p.position = new PVector(width/2, height/2);
      p.radius = random(minRadius, maxRadius);
      p.colour = color(random(0, 45), random(75, 100), random(50, 100));
      particles.add(p);
    }
  }
  
  /**
   * This is where the controller manages the pool.
   *
   * This is quite a complex function but it's well commented.
   */
  void update() {
    /* This first loop allows us to work on each and every particle in the pool. */
    for(int i = 0; i < particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      // This is not strictly needed but it adds a bit of action.
      p.velocity.add(new PVector(random(-0.01, 0.01), random(-0.01, 0.01)));

      // These three lines attract the particles to the center of the window.
      // First, retrieve the vector going from the particle to the center...
      PVector dirToCenter = PVector.sub(p.position.get(), new PVector(width/2, height/2));
      // Then do some mumbo-jumbo to scale it down so we can...
      dirToCenter.div(1000*(maxRadius/p.radius));
      // ... subtract it from the velocity vector...
      p.velocity.sub(dirToCenter);
      // ... and this moves the particle toward the center of the window!

      /* This is where we make particles that are too close to each other make
       * room for themselves by pushing the others away. But don't worry, the
       * other will do the same to us so we're even :)
       * 
       * Now we need to match our particle p to all the other particles in the
       * pool but here's the catch: if we start with particle 0 and match it to
       * all the others, let's take for example particle 8, when we get to
       * particle 8 we should match it to all the particles in the pool,
       * including 0. But hey, we've already done that! So the trick is to start
       * matching from the "next" particle to the end of the pool so we save
       * a lot of matches! Not to mention our current particle itself!
       */
      for(int j = i+1; j < particles.size(); j++) {
        // This is the particle right next to the one at position i in the pool.
        Particle q = (Particle) particles.get(j);
        // We need a copy of p's position to calculate the vector that goes...
        PVector direction = p.position.get();
        // ... from q to p, therefore the direction along which we need to push.
        direction.sub(q.position);
        // Then we see if the particles are too close to each other...
        float threshold = (p.radius + q.radius)*50;
        if(direction.mag() < threshold) {
          // ... and if that's the case we do some voodoo and calculate...
          float dSqr = direction.mag() * direction.mag() * direction.mag();
          if(dSqr > 0.0f) {
            float force = (direction.mag()*p.radius) / dSqr;
            direction.normalize();
            direction.mult(force);
            // ... the vector that pushes them apart. Cool uh?
            p.acceleration.add(direction);
            q.acceleration.sub(direction);
          }
        }
      }
    }
    
    // At this point we just need to call the particle's update function that
    // will take care of all the heavy lifting to move it according to our will.
    for(int i = 0; i < particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      p.update();
    }
  }

  /**
   * Possibly the least surprising function, responsible for telling the
   * particles we want them to draw themselves.
   */
  void draw() {
    for(int i = 0; i < particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      p.draw();
    }
  }
}
