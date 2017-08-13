class Sloths{
  ArrayList<Sloth> sloths;
  Sloths(){
     sloths = new ArrayList<Sloth>();
     sloths.add(new Sloth(random(width), random(height), true));
     sloths.add(new Sloth(random(width), random(height), false));
  }
  void run(World world){
    for(Sloth s: sloths){
      s.run(world);
    }
  }
  
}