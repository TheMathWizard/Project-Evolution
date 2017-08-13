class World{
  Sloths sloths;
  Flock flock;
  Boid player;
  World(Flock flock, Sloths sloths, Boid you){
    this.flock = flock;
    this.sloths = sloths;
    this.player = you;
  }
  void run(){
     flock.run(this);
     sloths.run(this);
     player.run(this);
  }
}