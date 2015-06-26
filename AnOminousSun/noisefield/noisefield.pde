/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/3897*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

int NUM_PARTICLES = 1000;

ParticleSystem p;

void setup()
{
  smooth();
  size(1000,1000);
  background(0);
  
  p = new ParticleSystem();
}

void draw()
{   
  noStroke();
  
  fill(0,5);
  rect(0,0,width,height);
  
  //change the particle number 
  if(frameCount % 10 == 0)
  {
    NUM_PARTICLES += random(-200,200);
    if(NUM_PARTICLES < 0)
      NUM_PARTICLES = 1000;
    
    p.updateParticleList();
    println(NUM_PARTICLES);
  }
  
  p.update();
  p.render();
}
