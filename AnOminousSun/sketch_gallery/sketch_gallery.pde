/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/9292*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import napplet.*;

PFont mainFont;

void setup() {
  size(800, 400);
    mainFont = loadFont("C:/Users/Gebruiker/Documents/Visual Studio 2013/Projects/AnOminousSun/AnOminousSun/sketch_gallery/data/ArialMT-18.vlw");
  textMode(SCREEN);
  textAlign(CENTER, TOP);
  
  NAppletManager nappletManager = new NAppletManager(this);

  nappletManager.createNApplet("Scrollbar", 0, 0);
  nappletManager.createNApplet("Pattern", 200, 0);
  nappletManager.createNApplet("Convolution", 400, 0);
  nappletManager.createNApplet("Animator", 600, 0);
  nappletManager.createNApplet("BouncyBubbles", 0, 200);
  nappletManager.createNApplet("FireCube", 200, 200);
  nappletManager.createNApplet("Tickle", 400, 200);
  nappletManager.createNApplet("UnlimitedSprites", 600, 200);
}

void draw() {
  background(50);
  
}

