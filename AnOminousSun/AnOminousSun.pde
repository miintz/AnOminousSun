

// AT THE GATES OF THE VOID, DARK SPIRITS RISING, AN OMINOUS SUN, PIERCING THE CIRCULAR RUINS

ArrayList<AppletInterface> Visuals = new ArrayList<AppletInterface>(); 
int DrawThisOne = 1;

void setup()
{
  size(1000, 1000, P3D); //P3D heeft ook de P2D functies blijkbaar 

  Visuals.add(new DummyVisual()); //dummy

  BodyCells Cells = new BodyCells();
  Cells.that = this;
  Cells.setup();
  Visuals.add(Cells);
  
  NoiseField Noise = new NoiseField();
  Noise.setup();  
  Visuals.add(Noise);
  
  McCabe Cabe = new McCabe();
  Cabe.setup();
  Visuals.add(Cabe);
  
  Fabric FabricSim = new Fabric();
  FabricSim.setup();  
  Visuals.add(FabricSim);
  
  MultiscaleTuring Turing = new MultiscaleTuring();
  Turing.setup();  
  Visuals.add(Turing); 
}

void draw()
{
  Visuals.get(DrawThisOne).draw();
}
boolean ctrlPressed;
void keyPressed()
{
  Visuals.get(DrawThisOne).keyPressed();
  
  if(!ctrlPressed) //possibly cntrl
  {      
    int k = int(str((char)key));
    if(k != 0 && Visuals.size() > k)
      DrawThisOne = k;
  }    
  else //if its ctrlpressed its meant for the applet not this
  {
    Visuals.get(DrawThisOne).keyPressed();      
  }
  
  if(keyCode == CONTROL)
    ctrlPressed = true;
  else
    ctrlPressed = false;
    
}

void keyReleased()
{
  Visuals.get(DrawThisOne).keyReleased();
}


