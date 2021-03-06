// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

float swt = 100.0;     //sep.mult(25.0f);
float awt = 4.0;      //ali.mult(4.0f);
float cwt = 5.0;      //coh.mult(5.0f);
float maxspeed = 3;
float maxforce = 0.025;


// Flocking
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2009

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {
  PVector loc;
  PVector vel;
  PVector acc;
  PVector alarm;
  float r;

  Boid(float x, float y) {
    acc = new PVector(0,0);
    alarm = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    loc = new PVector(x,y);
    r = 2.0;
  }

  void run(ArrayList<Boid> boids, Sloths sloths) {
    flock(boids, sloths);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, Sloths sloths) {
    PVector sep = separate(boids);   // Separation
    alarm  = separate(sloths);
    PVector next = alarm(boids);
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    alarm.mult(100);
    next.mult(50);
    sep.mult(swt);
    ali.mult(awt);
    coh.mult(cwt);
    // Add the force vectors to acceleration
    applyForce(next);
    applyForce(alarm);
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update locition
  void update() {
    // Update velocity
    acc.limit(maxforce);
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,loc);  // A vector pointing from the locition to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + radians(90);
    if(alarm.mag()>0)
      fill(255,0,0);
    else
      fill(175);
    stroke(0);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 10.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector steer = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average locition (i.e. center) of all nearby boids, calculate steering vector towards that locition
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locitions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add locition
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the locition
    }
    return sum;
  }
  PVector alarm(ArrayList<Boid> boids){
    float desiredseparation = 50.0;
    int count = 0;
    PVector steer = new PVector(0,0);
     for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        steer.add(other.alarm);
        
        count++;            // Keep track of how many
      }
    }
    if(count > 0)
      steer.div(count);
    return steer;
  }
  PVector separate (Sloths sloths){
    float desiredseparation = 50.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    for(int i = 0; i < sloths.sloths.size(); i++){
      Sloth sloth = sloths.sloths.get(i);
      float d = PVector.dist(loc,sloth.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation+sloths.sloths.get(0).r)) {
          count++;
          PVector diff = PVector.sub(loc,sloth.loc);
          diff.normalize();
          diff.mult(1/d);
          steer.add(diff);
          steer.normalize();
      }
    }
    if(count > 0){
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
      
    }
      //println("after: "+steer.mag());
    return steer;
  }
}