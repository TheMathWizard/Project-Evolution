// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com


// Flocking
// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system
Flock flock;
Sloths sloths;
World world;
PVector center;

boolean showvalues = true;
boolean scrollbar = false;
boolean first = true;
float startTime, xt = 0;
int sec, min;

void setup() {
  size(displayWidth,displayHeight,P2D);
  setupScrollbars();
  center = new PVector(width/2,height/2);
  colorMode(RGB,255,255,255,100);
  world = new World(new Flock(),new Sloths());
  // Add an initial set of boids into the system
  for (int i = 0; i < 120; i++) {
    world.flock.addBoid(new Boid(width/2,height/2));
  }
  smooth();
}


void draw() {
  if(first){ 
    first = false;
  }
  background(255);
  world.run();
  drawScrollbars();
  if((world.flock.boids.size()<120))
    world.flock.addBoid(new Boid(random(width), random(height)));
  if ((mousePressed && !scrollbar)) {
    world.flock.addBoid(new Boid(mouseX,mouseY));
  }

  if (showvalues) {
    fill(0);
    textAlign(LEFT);
    xt += 1.0/frameRate;
    sec = round(xt)%60;
    min = round(xt)/60;
    text("Time: "+min+"min "+sec +"sec", 5, 100);
    //text("Total boids: " + flock.boids.size() + "\n" + "Framerate: " + round(frameRate) + "\nMass: "+(float)round(sloth.mass*100)/100+"\nVelocity: " + (float)round(sloth.vel.mag()*100)/100+"\nMax Force Diffusion: "+ (float)round(sloth.maxForce*100000)/100000+"\nDiffusion Rate: "+ (float)round(sloth.diffusion*100000)/100000+"\nMax Mass Diffusion Rate: "+ (float)round(sloth.maxMass*100000)/100000+ "\nEnergy: "+ (float)round(sloth.energy*100)/100+"\nSize: "+ (float)round(sloth.r*100)/100+ "\nPress any key to show/hide sliders and text\nClick mouse to add more boids",5,100);
  }
}

void keyPressed() {
  /*if(key == 'w'){
    sloth.applyForce(new PVector(0,-1));
  }
  else if(key == 's'){
    sloth.applyForce(new PVector(0,1));
  }
  else if(key == 'a'){
    sloth.applyForce(new PVector(-1,0));
  }
  else if(key == 'd'){
    sloth.applyForce(new PVector(1,0));
  }
  else*/
    showvalues = !showvalues;
}

void mousePressed() {
}