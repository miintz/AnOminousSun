// AT THE GATES OF THE VOID, 
// DARK SPIRITS RISING, 
// AN OMINOUS SUN, 
// PIERCING THE CIRCULAR RUINS

int L_SWAPTIME = 5;
int ALO_SWAPTIME = 240; //frames!!
int L_WORDTIME = 5;
int ALO_SHOW = 3;

PFont ACTIVE_FONT;
int ACTIVE_FONTSIZE = 16;

int word = 0; //dit word een lijst...

ArrayList<AppletInterface> Visuals = new ArrayList<AppletInterface>(); 
ArrayList<LyrSerObject> LyricObjects = new ArrayList<LyrSerObject>();
ArrayList<PFont> LyricFonts = new ArrayList<PFont>();
LyrSerObject ActiveLyricObjects[] = new LyrSerObject[ALO_SHOW];

float FirstAngle;
float SecondAngle;
float jitter;

int DrawThisOne = 1;

boolean ctrlPressed;

PImage tex0;
PImage tex1;
PImage tex2;
PImage tex3;
PImage tex4;
PImage tex5;

PImage bck;
PImage Mask;
PImage MaskInv;


void setup()
{ 
  size(1000, 1000, P3D); //P3D heeft ook de P2D functies blijkbaar

  bck = loadImage("TheSun/Stage0.png");

  tex0 = loadImage("TheSun/Stage1.png");
  tex1 = loadImage("TheSun/Stage2.png");
  tex2 = loadImage("TheSun/Stage3.png");
  tex3 = loadImage("TheSun/Stage4.png");
  tex4 = loadImage("TheSun/Stage5.png");
  tex5 = loadImage("TheSun/Stage6.png");

  Mask = loadImage("mask.jpg");
  MaskInv = loadImage("maskInv.png");  

  Visuals.add(new DummyVisual()); //dummy

  BodyCells Cells = new BodyCells();
  Cells.that = this;
  Cells.setup();
  Visuals.add(Cells);

//  NoiseField Noise = new NoiseField();
//  Noise.setup();  
//  Visuals.add(Noise);
//
//  Knitting Knitter = new Knitting();
//  Knitter.setup();
//  Visuals.add(Knitter);
//
//  McCabe Cabe = new McCabe();
//  Cabe.setup();
//  Visuals.add(Cabe);
//
//  Fabric FabricSim = new Fabric();
//  FabricSim.setup();  
//  Visuals.add(FabricSim);
//
//  Doodle Doodoo = new Doodle();
//  Doodoo.setup();
//  Visuals.add(Doodoo);
//
//  Letters Lett = new Letters();
//  Lett.setup();
//  Visuals.add(Lett);
//
//  Waver Wave = new Waver();
//  Wave.setup();
//  Visuals.add(Wave);  

  //deze centered niet zo goed
  //Octo Oct = new Octo();
  //Oct.setup();
  //Visuals.add(Oct);  

  //te zwaar op de CPU + McCabe doet ongv hetzelfde
  //MultiscaleTuring Turing = new MultiscaleTuring();
  //Turing.setup();  
  //Visuals.add(Turing); 
  //erg traag

  LoadFonts();
  LoadFileList();  
}


void draw()
{
  //de tekst word over de applet heen getekend als een soort color burn achtig iets. we houwe het lekker vaag dus.
  //applets omschrijven dus 

  //de laatste heeft voorrang, de kans dat voorgaande getoond worden is steeds lager... 
  //krijg je mss semi smooth over gang in het hele eviless-gedoe

  //teksten zijn een x aantal seconden geldig, dan moet file leeg?

  Visuals.get(DrawThisOne).draw();

  loadPixels();
  //mask pixels

  PImage frame = createImage(width, height, RGB);
  frame.loadPixels();

  for (int z = 0; z < (width*height); z++)
  {
    frame.pixels[z] = pixels[z];
    pixels[z] = 0;
  }

  updatePixels();  
  frame.updatePixels();  

  frame.mask(Mask);
  image(frame, 0, 0);      
  doSwirlyDo();

  AnOminousSun();
  
  //image(Mask,0,0); 
  //applyRandomFilter();
}

//GFX section

void AnOminousSun()
{    
  for(int i = 0; i < ALO_SHOW; i++)
  {
    fill(0); 
    
    if(ActiveLyrisObjects[i] == null)
      continue;
      
    textFont(ActiveLyricObjects[i].ActiveFont); //random font
    textSize(ACTIVE_FONTSIZE);   
    text(ActiveLyricObjects[i].returnCurrent(), 500, 500 + (i * 50));
    
    if(frameCount % ActiveLyricObjects[i].Evilness == 0)
    {      
      ACTIVE_FONTSIZE = (int)ceil(random(22, 32));
    }
    
    if(frameCount % 7 == 0)
    {      
      int font = (int)ceil(random(0,LyricFonts.size() - 1));      
      ActiveLyricObjects[i].ActiveFont = LyricFonts.get(font);
    }
    
    if(frameCount % L_WORDTIME == 0)
    {
       word++;
    }
    
    if(frameCount % L_SWAPTIME == 0)
    {
       ActiveLyricObjects[i].Progress += 3;     
       word = 0;
    }
    
    Boolean dontreset = false;
    if(frameCount % ALO_SWAPTIME == 0)
    {
      //de swap is hier, mss moeten we een object verwijderen
      if(ActiveLyricObjects[i].Invalidated)
      {        
        if(ALO_SHOW != LyricObjects.size()
        {        
          LyricObjects.remove(ActiveLyricObjects[i].Index);       
        }
        else
          dontreset = true;
        //no more objects
        
        if(ALO_SHOW > LyricObjects.size())
        {
          ALO_SHOW = LyricObjects.size();  
          println("reset: " + ALO_SHOW);
        }
        
        println("removed: " + i + " new size: " + LyricObjects.size());
      }
      
      int y = (int)floor(random(0, LyricObjects.size()));
      
      if(!dontreset)
      {
        ActiveLyricObjects[i] = LyricObjects.get(y);
        //chance index
        ActiveLyricObjects[i].Index = y;
      }
      else
        ActiveLyrisObjects[i] = null;      
    }
  }
}

void fadeAlongEvilness()
{
  //doe wat dingen als een nieuwe file ingeladen word, flitsende dingen? adh evilness
}

void doSwirlyDo()
{
  //dit moet het 'zon' aspect doen, een soort golvende zooi als het oppervlak van de zon
  pushMatrix();

  FirstAngle += 0.002;
  SecondAngle += 0.6;

  float fc = cos(FirstAngle);
  float sc = cos(SecondAngle);

  translate(width/2, height/2);

  rotate(fc);

  //SUBTRACT werkt met 0

  ConfiguredBlendMode(DrawThisOne);
  InitialConfiguredFilter(DrawThisOne);
  //blendMode(SUBTRACT);

  image(tex3, -500, -500, height, width);
  //blendMode(SUBTRACT);
  rotate(sc);

  image(bck, -500, -500, height, width);
  blendMode(BLEND);

  //ook met 0
  ConfiguredFilter(DrawThisOne);
  //filter(INVERT);

  translate(0, 0);     
  popMatrix();   

  //image(Mask,0,0);
}

void applyRandomFilter()
{
  if (frameCount % 5 == 0)
  {
    int f = (int)round(random(0, 2));
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

void InitialConfiguredFilter(int filterMode)
{
  switch(filterMode)
  {
  case 1:
    break;
  default:
    break;
  }
}

void ConfiguredBlendMode(int blendMode)
{  
  switch(blendMode)
  {
  case 1:
    blendMode(SUBTRACT); //cells
    break;
  case 2:

    break;
  case 3:
    break;
  case 4:
    //McCabe
    blendMode(EXCLUSION);
    //tint(226,133,7);
    break;
  case 5:
    break;
  case 6:
    break;
  case 99:
    break;
  default:
    break;
  }
}

void ConfiguredFilter(int filterMode)
{

  switch(filterMode)
  {
  case 1:
    filter(INVERT);
    break;
  case 2:
    break;
  case 3:
    break;
  case 4:
    //filter(INVERT); 
    break;
  case 5:         
    break;
  case 6:
    break;
  case 99:
    break;
  default:      
    break;
  }
}

//control section

void keyPressed()
{
  Visuals.get(DrawThisOne).keyPressed();
  if (!ctrlPressed) //possibly cntrl
  {          
    int k = int(str((char)key));
    if (k != 0 && Visuals.size() > k)
    {
      DrawThisOne = k;
      background(255);
    }
  } else //if its ctrlpressed its meant for the applet not this
  {
    Visuals.get(DrawThisOne).keyPressed();
  }

  if (keyCode == CONTROL)
    ctrlPressed = true;
  else
    ctrlPressed = false;
}

void keyReleased()
{
  Visuals.get(DrawThisOne).keyReleased();
}

/// Load functions 

void LoadFonts()
{
  File dir = new File("M:/Edit/Code/Projects/NR/AnOminousSun/data/fonts");

  String[] children = dir.list();    
  
  if (children == null) 
  {
    // Either dir does not exist or is not a directory
    println("error bliep (font files)");
  } else 
  {    
    for (int i=0; i<children.length; i++) 
    {  
      LyricFonts.add(createFont("M:/Edit/Code/Projects/NR/AnOminousSun/data/fonts/" + children[i], 16));      
    }        
  }  
}

void LoadFileList()
{
  File dir = new File("M:/Edit/Code/Projects/NR/AnOminousSun/lyrser/");

  String[] children = dir.list();  
  
  if (children == null) 
  {
    // Either dir does not exist or is not a directory
    println("error bliep (lyr files)");
  } else 
  {    
    for (int i=0; i<children.length; i++) 
    {      
      String filename = children[i];
      
      JSONObject a = loadJSONObject("M:/Edit/Code/Projects/NR/AnOminousSun/lyrser/" + filename);      
      
      LyrSerObject b = new LyrSerObject(Float.valueOf(a.getString("Evilness")), a.getString("Genres"), a.getString("Lyrics"));
      
      b.Index = i;
      b.ActiveFont = LyricFonts.get(0);
            
      LyricObjects.add(b);      
    }
  }

  for(int i = 0; i < ALO_SHOW; i++)
  {
    ActiveLyricObjects[i] = LyricObjects.get(i);
  }  
}
