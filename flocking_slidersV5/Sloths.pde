class Sloths{
  ArrayList<Sloth> sloths;
  Sloths(){
     sloths = new ArrayList<Sloth>();
     for(int i = 0; i < 5; i++){
       sloths.add(new Sloth(random(width), random(height), new DNASloth()));
       sloths.add(new Sloth(random(width), random(height), new DNASloth()));
     }
  }
  void addNew(Sloth s){
    sloths.add(s); 
  }
  void remove(Sloth s){
    sloths.remove(s); 
  }
  void run(World world){
    for(int i = 0; i < sloths.size(); i++){
      sloths.get(i).run(world);
    }
  }
}