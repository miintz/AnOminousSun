// AT THE GATES OF THE VOID, 
// DARK SPIRITS RISING, 
// AN OMINOUS SUN, 
// PIERCING THE CIRCULAR RUINS

ArrayList<AppletInterface> Visuals = new ArrayList<AppletInterface>(); 
int DrawThisOne = 1;

void setup()
{
  size(1000, 1000, P3D); //P3D heeft ook de P2D functies blijkbaar 

  //Visuals.add(new DummyVisual()); //dummy

  
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
  
  Doodle Doodoo = new Doodle();
  Doodoo.setup();
  Visuals.add(Doodoo);
  
  Letters Lett = new Letters();
  Lett.setup();
  Visuals.add(Lett);
    
  //deze centered niet zo goed
  //Octo Oct = new Octo();
  //Oct.setup();
  //Visuals.add(Oct);  
  
  //te zwaar op de CPU + McCabe doet ongv hetzelfde
  //MultiscaleTuring Turing = new MultiscaleTuring();
  //Turing.setup();  
  //Visuals.add(Turing); 
  //erg traag
}

void draw()
{
  Visuals.get(DrawThisOne).draw();
  
  //random filter?
  if(frameCount % 5 == 0)
  {
    int f = (int)round(random(0,2));
    println(f);
    
    switch(f)
    {
      case 0:
        filter(DILATE);
      break;
      case 1:
        filter(ERODE);
      break;
      case 2:
        filter(POSTERIZE, 4);
      break;      
    }  
  }
}
boolean ctrlPressed;
void keyPressed()
{
  Visuals.get(DrawThisOne).keyPressed();
  
  if(!ctrlPressed) //possibly cntrl
  {      
    int k = int(str((char)key));
    if(k != 0 && Visuals.size() > k)
    {
      DrawThisOne = k;
      background(255);
    }
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


