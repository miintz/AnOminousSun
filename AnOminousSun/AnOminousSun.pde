// AT THE GATES OF THE VOID, DARK SPIRITS RISING, AN OMINOUS SUN, PIERCING THE CIRCULAR RUINS

ArrayList<AppletInterface> Visuals = new ArrayList<AppletInterface>(); 
int DrawThisOne = 1;

void setup()
{
  size(1000, 1000, P2D);
  //list of visual effects

  Visuals.add(new DummyVisual()); //dummy
  
  
  Fabric FabricSim = new Fabric();
  FabricSim.setup();  
  Visuals.add(FabricSim);
  
  MultiscaleTuring Turing = new MultiscaleTuring();
  Turing.setup();  
  Visuals.add(Turing); 
  
  
  NoiseField Noise = new NoiseField();
  Noise.setup();  
  Visuals.add(Noise);    
}

void draw()
{
  Visuals.get(DrawThisOne).draw();
}

void keyPressed()
{
  Visuals.get(DrawThisOne).keyPressed();
  
  try
  {    
    int k = int(str((char)key));
    if(k != 0 && Visuals.size() > k)
      DrawThisOne = k;
  }
  catch(Exception E)
  {}
}


void keyReleased()
{
  Visuals.get(DrawThisOne).keyReleased();
}


