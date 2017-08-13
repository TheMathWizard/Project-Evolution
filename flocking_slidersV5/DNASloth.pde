class DNASloth{
  float[] genes;
  DNASloth(){
    genes = new float[19];
    for(int i = 0; i < genes.length; i++){
      genes[i] = randomGene(i); 
    }
  }
  DNASloth(float[] newgenes){
    genes = newgenes; 
  }
  DNASloth crossover(DNASloth partner){
    float[] child = new float[genes.length];
    for (int i = 0; i < genes.length; i++) {
      if (random(1)>.5) child[i] = genes[i];
      else               child[i] = partner.genes[i];
    }    
    DNASloth newgenes = new DNASloth(child);
    return  newgenes;
  }
  void mutate(float m){
     for(int i = 0; i < genes.length; i++){
       if(random(1)<m){
          genes[i] = randomGene(i);
       }
     }
  }
  float randomGene(int i){
    switch(i){
           case 0:
             return floor(random(2));
              
           case 1:
             return random(5,15);
              
           case 2:
             return random(5,15);
              
           case 3:
             return random(20);
              
           case 4:
             return random(50);
              
           case 5:
             return random(3,8);
              
           case 6:
             return random(3);
              
           case 7:
             return random(1);
              
           case 8:
             return random(.05,.5);
              
           case 9:
             return random(.5,1.5);
              
           case 10:
             return random(2);
              
           case 11:
             return random(1);
              
           case 12:
             return random(75,150);
              
           case 13:
             return random(100,250);
              
           case 14:
             return random(20,30);
              
           case 15:
             return round(random(1,6));
           case 16:
             return random(255);
           case 17:
             return random(255);
           case 18:
             return random(255);
         }
         return 0;
  }
  float fitness(){
     return map(genes[2], 5, 15, 0, 5)* map(genes[3], 0, 20, 0, 2)* map(genes[6],0,3,0,2)* map(genes[7],0,1,0,5)* map(genes[10],0,2,0,5)* map(genes[9],.5,1.5,0,2)* map(genes[13], 100, 250, 0, 3)* map(genes[15],1, 6, 0, 4);
  }
  
}
// The genetic sequence

  /*PVector[] genes;

gender            0
gestPeriod        1
visionDist        2
soundRadius       3
restTime          4
matingPeriod      5  
visionAngle        6
shielding        7
maxforce          8
maxvelocity      9
hitrate          10
generosity        11
maxsize          12
oldage            13
pubertity        14
babies            15  
eyecolor


  // The maximum strength of the forces
  float maxforce = 0.1;

  // Constructor (makes a DNA of random PVectors)
  DNA() {
    genes = new PVector[lifetime];
    for (int i = 0; i < genes.length; i++) {
      float angle = random(TWO_PI);
      return new PVector(cos(angle), sin(angle));
      genes[i].mult(random(0, maxforce));
    }
  }

  // Constructor #2, creates the instance based on an existing array
  DNA(PVector[] newgenes) {
    // We could make a copy if necessary
    // genes = (PVector []) newgenes.clone();
    genes = newgenes;
  }

  // CROSSOVER
  // Creates new DNA sequence from two (this & and a partner)
  DNA crossover(DNA partner) {
    PVector[] child = new PVector[genes.length];
    // Pick a midpoint
    int crossover = int(random(genes.length));
    // Take "half" from one and "half" from the other
    for (int i = 0; i < genes.length; i++) {
      if (i > crossover) child[i] = genes[i];
      else               child[i] = partner.genes[i];
    }    
    DNA newgenes = new DNA(child);
    return  newgenes;
  }

  // Based on a mutation probability, picks a new random Vector
  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
        float angle = random(TWO_PI);
        return new PVector(cos(angle), sin(angle));
        genes[i].mult(random(0, maxforce));
      }
    }
  }*/