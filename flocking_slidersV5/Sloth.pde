

class Sloth{
  float r;
  // mating properties
  float matingPeriod = 5, startMating, endMating, restTime = 30, startGest, endGest, gestPeriod = 10;
  boolean gender;
  int babies;
  float deprive, lastTime;
  Sloth desiredPartner;
  boolean beingHit = false;
  String state;
  World world;
  PVector loc, acc, vel, look;
  float energy, maxspeed, maxforce, mass, visionDist, visionAngle, soundRadius, maxMass, maxForce, diffusion, visionDistFact, soundRadiusFact;
  float bornTime;
  float[] eyecolor = new float[3];
  float shielding, oldage, puberty, maxsize, generosity, hitrate;
  DNASloth dna;
  String[] dnaprop = {"gender",  
"gestPeriod",  
"visionDist",  
"soundRadius",  
"restTime",  
"matingPeriod",  
"visionAngle",  
"shielding",  
"maxforce",  
"maxvelocity",  
"hitrate",  
"generosity",  
"maxsize",  
"oldage",  
"puberty",  
"babies"  };
  Sloth(float x, float y, boolean male){
     r = 10;
     bornTime = xt;
     lastTime = 0;
     gender = male;
     maxMass = maxForce = 0;
     energy = 100;
     loc = new PVector(x, y);
     look = new PVector();
     maxspeed = 1;
     diffusion = 0;
     babies = 4;
     visionAngle = 1;
     visionDistFact = 10;
     soundRadiusFact = 4;
     acc = new PVector(0,0);
     vel = new PVector(random(-1,1),random(-1,1));
     state = "prey";
  }
  Sloth(float x, float y, DNASloth dna){
     lastTime = 0;
     gender = dna.genes[0]==1?true:false;
     gestPeriod = dna.genes[1];
     visionDistFact = dna.genes[2];
     soundRadiusFact = dna.genes[3];
     restTime = dna.genes[4];
     matingPeriod = dna.genes[5];
     visionAngle = dna.genes[6];
     shielding = dna.genes[7];
     maxforce = dna.genes[8];
     maxspeed = dna.genes[9];
     hitrate = dna.genes[10];
     generosity = dna.genes[11];
     maxsize = dna.genes[12];
     oldage = dna.genes[13];
     puberty = dna.genes[14];
     babies = (int)dna.genes[15];
     eyecolor[0] = dna.genes[16];
     eyecolor[1] = dna.genes[17];
     eyecolor[2] = dna.genes[18];
     acc = new PVector(0,0);
     vel = new PVector(random(-1,1),random(-1,1));
     r = 10;
     bornTime = xt;
     energy = 100;
     loc = new PVector(x, y);
     look = new PVector();
     this.dna = dna;
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
     //display();
  }
  void duel(){
     
  }
  void gestate(Sloths sloths){
    energy+=.5;
    float a = xt;
    float b = startGest;
    //println("ges: "+a);
    //println("start: "+b);
    if((a-b) > gestPeriod){
      for(int i = 0; i < babies; i++){
        DNASloth baby = dna.crossover(desiredPartner.dna);
        baby.mutate(.01);
        Sloth s = new Sloth(loc.x, loc.y, baby);
        sloths.addNew(s);
      }
      desiredPartner = null;
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
    if(gender)
    desiredPartner = null;
  }
  float age(){
    return xt-bornTime;
  }
  void health(Sloths sloths){
    visionDist = r*visionDistFact;
    deprive = age()- lastTime;
    soundRadius = r*soundRadiusFact;
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
       //println("energy "+energy);
     if(diffusion>maxMass)
       maxMass = diffusion;
     if(energy < 25)
        sloths.remove(this);
     
  }
  boolean ffm(){
    return ((energy > 200) && (xt-endMating > restTime));
  }
  boolean compatible(Sloth s){
    if(abs(s.dna.fitness()-dna.fitness())<10)
      return true;
    if(deprive > oldage/4)
      return true;
    return false;
  }
  void findMate(Sloths sloths){
     for(int i = 0; i < sloths.sloths.size(); i++){
       Sloth sloth = sloths.sloths.get(i);
       if(inView(sloth)){
         //println(dna.fitness());
         if(sloth.gender != gender && sloth.ffm() && this.ffm() && compatible(sloth)){
           desiredPartner = sloth;
           if(sloth.desiredPartner != null && sloth.desiredPartner == this){
             startMating = xt;
             lastTime = age();
             state = "breed";
           }
         }
         else{
         if((PVector.dist(sloth.loc, loc) < (r+sloth.r))&&(energy-sloth.energy > 100)&&(sloth.age()>25)){
             this.energy += sloth.hit(hitrate);
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
    this.energy -= shielding*damage;
    beingHit = true;
    return damage*shielding;
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
    fill(eyecolor[0], eyecolor[1], eyecolor[2]);
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