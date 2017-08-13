
class Sloth{
  float r;
  // mating properties
  float matingPeriod = 5, startMating, endMating, restTime = 30, startGest, endGest, gestPeriod = 10;
  boolean gender;
  ArrayList<Sloth> babies = new ArrayList<Sloth>();
  Sloth desiredPartner;
  boolean beingHit = false;
  String state;
  World world;
  PVector loc, acc, vel, look;
  float energy, maxspeed, maxforce, mass, visionDist, visionAngle, soundRadius, maxMass, maxForce, diffusion;
  float bornTime;
  Sloth(float x, float y, boolean male){
     r = 10;
     bornTime = xt;
     gender = male;
     maxMass = maxForce = 0;
     energy = 100;
     loc = new PVector(x, y);
     look = new PVector();
     maxspeed = 1;
     diffusion = 0;
     visionAngle = 1;
     visionDist = r*10 ;
     soundRadius = r*4;
     acc = new PVector(0,0);
     vel = new PVector(random(-1,1),random(-1,1));
     state = "prey";
  }
  PVector line;
  PVector resultant = new PVector();
  void run(World world){
     //println(loc.x, loc.y);
     health(world.sloths);
     update();
     
     switch(state){
       case "prey":
         preying(world.flock);
         findMate(world.sloths);
         break;
       case "breed":
         reproduce();
         break;
       case "gestate":
         gestate(world.sloths);
         break;
       case "duel":
         duel();
         break;
     }
     
     
     borders();
     display();
  }
  void duel(){
     
  }
  void gestate(Sloths sloths){
    energy+=.5;
    float a = xt;
    float b = startGest;
    println("ges: "+a);
    println("start: "+b);
    if((a-b) > gestPeriod){
      for(int i = 0; i < 4; i++){
        Sloth s = new Sloth(loc.x, loc.y, random(1)>.5);
        sloths.addNew(s);
        babies.add(s);
      }
      endGest = xt;
      state = "prey";
      energy -= 200;
    }
  }
  void reproduce(){
     //energy += .0001*mass;
     applyForce(seek(PVector.sub(desiredPartner.loc, loc)));
     //println("rep: "+(System.currentTimeMillis()));
     //println("start: "+(startMating));
     if(xt-startMating > matingPeriod){
       resetRep();
       if(gender)
         state = "prey";
       else {
         startGest =xt;
         state = "gestate";
       }
     }
  }
  void resetRep(){
    endMating = xt;
    desiredPartner = null;
  }
  float age(){
    return xt-bornTime;
  }
  void health(Sloths sloths){
    r = energy/10;
    if(r >= 100)
       r = 100;
     if(r <= 5)
       r = 5;
     mass = pow(r, 2)/2500;
     maxforce = maxspeed/5;
     diffusion = .001*(mass);
     if(age()>200)
       diffusion = .01*(mass);
     if(!(state.equals("breed") && (energy <= 75)))
       energy = energy*(1-diffusion);
     else
       println("energy "+energy);
     if(diffusion>maxMass)
       maxMass = diffusion;
     if(energy < 25)
        sloths.remove(this);
     
  }
  boolean ffm(){
    return ((energy > 200) && (xt-endMating > restTime));
  }
  void findMate(Sloths sloths){
     for(int i = 0; i < sloths.sloths.size(); i++){
       Sloth sloth = sloths.sloths.get(i);
       if(inView(sloth)){
         if(sloth.gender != gender && sloth.ffm() && this.ffm()){
           desiredPartner = sloth;
           if(sloth.desiredPartner != null && sloth.desiredPartner == this){
             startMating = xt;
             state = "breed";
           }
         }
         else{
         if((PVector.dist(sloth.loc, loc) < (r+sloth.r))&&(energy-sloth.energy > 100)&&(sloth.age()>25)){
             this.energy += sloth.hit(1);
           }
           if(beingHit){
             applyForce(seek(PVector.sub(loc, sloth.loc))); 
             beingHit = false;
           }
         }
       }
     }
  }
  float hit(float damage){
    this.energy -= damage;
    beingHit = true;
    return damage;
  }
  boolean inView(PVector target){
    PVector line = PVector.sub(target, this.loc);
    if((line.mag()<soundRadius)||(line.mag()<visionDist&&PVector.angleBetween(line,vel)<visionAngle/2)) 
      return true;
    return false;
  }
  boolean inView(Sloth target){
    PVector line = PVector.sub(target.loc, this.loc);
    if((line.mag()<soundRadius+target.r)||(line.mag()<visionDist+target.r&&PVector.angleBetween(line,vel)<visionAngle/2)) 
      return true;
    return false;
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
       if(inView(b.loc)){
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
    //if(!state.equals("breed"))
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