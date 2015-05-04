class NoiseField implements AppletInterface
{
  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/3897*@* */
  /* !do not delete the line above, required for linking your tweak if you upload again */

  int NUM_PARTICLES = 1000;

  ParticleSystem p;

  void setup()
  {
    smooth();
    //size(1000, 1000);
    background(0);

    p = new ParticleSystem();
  }

  void draw()
  {   
    noStroke();

    fill(0, 5);
    rect(0, 0, width, height);

    //change the particle number 
    if (frameCount % 10 == 0)
    {
      NUM_PARTICLES += random(-200, 200);
      if (NUM_PARTICLES < 0)
        NUM_PARTICLES = 1000;

      p.updateParticleList();
      println(NUM_PARTICLES);
    }

    p.update();
    p.render();
  }

  void keyPressed()
  {
  }

  void keyReleased()
  {
  }

  class Particle
  {
    public PVector position, velocity;

    Particle()
    {

      if (random(-1, 1) < 0)
        position = new PVector(random(random(-width, width)), random(random(-height, height)));
      else
        position = new PVector(random(width), random(height));  

      velocity = new PVector();
    }

    void update()
    {
      velocity.x = 20*(noise(mouseX/10+position.y/100)-0.5);
      velocity.y = 20*(noise(mouseY/10+position.x/100)-0.5);
      position.add(velocity);

      if (position.x<0)position.x+=width;
      if (position.x>width)position.x-=width;
      if (position.y<0)position.y+=height;
      if (position.y>height)position.y-=height;
    }

    void render()
    {
      stroke(255);
      line(position.x, position.y, position.x-velocity.x, position.y-velocity.y);
    }
  }

  class ParticleSystem
  {
    Particle[] particles;

    ParticleSystem()
    {
      particles = new Particle[NUM_PARTICLES];    
      for (int i = 0; i < NUM_PARTICLES; i++)
      {
        particles[i]= new Particle();
      }
    }

    void update()
    {
      for (int i = 0; i < NUM_PARTICLES; i++)
      {
        particles[i].update();
      }
    }

    void render()
    {
      int Cx = width / 2;
      int Cy = height / 2;

      int radius = width / 2;

      for (int i = 0; i < NUM_PARTICLES; i++)
      {
        float x = particles[i].position.x;
        float y = particles[i].position.y;

        if (pow((x - Cx), 2) + pow((y - Cy), 2) < pow(radius, 2))
          particles[i].render();
      }
    }

    void updateParticleList()
    {
      //copy to new list    
      if (particles.length < NUM_PARTICLES)
      {      
        //lijst moet groter
        int origlength = particles.length;
        Particle[] newParticles = new Particle[NUM_PARTICLES];
        arrayCopy(particles, 0, newParticles, 0, origlength);

        for (int i = particles.length; i < NUM_PARTICLES; i++)
        {                
          newParticles[i]= new Particle();
        }

        particles = newParticles;
      }
    }
  }
}

