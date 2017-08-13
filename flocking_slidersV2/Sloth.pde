class Sloth{
  float r;
  boolean gender;
  PVector loc, acc, vel, look;
  float energy, maxspeed, maxforce, mass, visionDist, visionAngle, soundRadius, maxMass, maxForce, diffusion;
  Sloth(float x, float y, boolean male){
     r = 10;
     gender = male;
     maxMass = maxForce = 0;
     energy = 100;
     loc = new PVector(x, y);
     look = new PVector();
     maxspeed = 1;
     diffusion = 0;
     visionAngle = 1;
     visionDist = r*10;
     soundRadius = r*4;
     acc = new PVector(0,0);
     vel = new PVector(random(-1,1),random(-1,1));
  }
  PVector line;
  PVector resultant = new PVector();
  void run(World world){
     //println(loc.x, loc.y);
     health();
     update();
     preying(world.flock);
     borders();
     display();
  }
  void health(){
    r = energy/10;
    if(r >= 100)
       r = 100;
     if(r <= 5)
       r = 5;
     mass = pow(r, 2)/2500;
     maxforce = maxspeed/5;
     diffusion = .001*(mass);
     
     energy = energy*(1-diffusion);
     if(diffusion>maxMass)
       maxMass = diffusion;
     
  }
  void preying(Flock flock){
    float count =0;
     for(Boid b: flock.boids){
       line = PVector.sub(b.loc, loc);
       if(line.mag()<r){
         eat(b, flock);
         //openmouth();
         look = vel.copy().normalize().mult(r/2);
         return; 
       }
       if((line.mag()<soundRadius)||(line.mag()<visionDist&&PVector.angleBetween(line,vel)<visionAngle/2)){
         float weight = 1/(line.mag() * PVector.angleBetween(b.vel, PVector.sub(loc, b.loc)));
         resultant.add(line.mult(weight));
         count+=weight;
       }
     }
     if(count > 0){
         resultant.mult(1/count);
         applyForce(seek(resultant));
         look = resultant.normalize().mult(r/2);
     }else 
       look = vel.copy().normalize().mult(r/2);
  }
  void eat(Boid b, Flock flock){
     energy += 5;
     flock.boids.remove(flock.boids.indexOf(b));
  }
  void applyForce(PVector force){
    diffusion = force.mag();
    acc.add(force);
    //println(diffusion);
    energy = energy-diffusion;
    if(diffusion>maxForce)
       maxForce = diffusion;
  }
  PVector seek(PVector desired) {  
    //println("hi");
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    float t = 10*exp(-pow(energy-500,2)/pow(200,2));
    PVector steer;
    steer = PVector.sub(desired,vel);
    //println(t);
    //println("energy : " + energy);
    // Limit to maximum steering force
    //if(t > 1)
      steer.limit(maxforce);
    //else
      //steer.limit(maxforce*t);
    //println(t);
    return steer;
  }
  void update(){
     vel.add(acc);
     vel.limit(maxspeed);
     //if(vel.mag() == maxspeed)
       //maxspeed+=.01;
     loc.add(vel);
     acc.mult(0);
  }
  void display(){
    //println("energy: "+ energy);
    if(gender == true)
    fill(0,0,255);
    else
    fill(0,255,0);
    ellipse(loc.x, loc.y, 2*r, 2*r); 
    fill(0);
    ellipse(loc.x+look.x, loc.y+look.y, r/3, r/3);
  }
  void openmouth(){
    
  }
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }
}