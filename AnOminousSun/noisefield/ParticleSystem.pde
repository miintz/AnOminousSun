class ParticleSystem
{
  Particle[] particles;
  
  ParticleSystem()
  {
    particles = new Particle[NUM_PARTICLES];    
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      particles[i]= new Particle();
    }
  }
  
  void update()
  {
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      particles[i].update();
    }
  }
  
  void render()
  {
    int Cx = width / 2;
    int Cy = height / 2;
    
    int radius = width / 2;
    
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      float x = particles[i].position.x;
      float y = particles[i].position.y;
      
      if(pow((x - Cx), 2) + pow((y - Cy), 2) < pow(radius, 2))
        particles[i].render();     
    }
  }
  
  void updateParticleList()
  {
    //copy to new list    
    if(particles.length < NUM_PARTICLES)
    {      
      //lijst moet groter
      int origlength = particles.length;
      Particle[] newParticles = new Particle[NUM_PARTICLES];
      arrayCopy(particles, 0, newParticles, 0, origlength);
       
      for(int i = particles.length; i < NUM_PARTICLES; i++)
      {                
        newParticles[i]= new Particle();
      }
      
      particles = newParticles;
    }
  }
}
