class World{
  Sloths sloths;
  Flock flock;
  World(Flock flock, Sloths sloths){
    this.flock = flock;
    this.sloths = sloths;
  }
  void run(){
     flock.run(this);
     sloths.run(this);
  }
}