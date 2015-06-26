import processing.core.*; 
import processing.xml.*; 

import megamu.mesh.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sketch_oct22a_2011 extends PApplet {

//Raven Kwok | \u90ed\u9510\u6587
//Email: raystain@gmail.com
//Blog: the-moor.blogbus.com
//Vimeo: vimeo.com/ravenkwok
//Weibo: weibo.com/ravenkwok
 


int total;
float xOffset, yOffset;
float [][] pos;
Particle [] particles;
Delaunay delaunay;

public void setup() {
  size(500, 500);
  smooth();
  background(255);
  total = 300;
  xOffset = width/2;
  yOffset = height/2;
  particles = new Particle[total];
  for (int i=0;i<total;i++) {
    particles[i] = new Particle(xOffset, yOffset);
  }
}
public void draw() {
  background(255);
  for (int i=0;i<total;i++) {
    particles[i].update();
    particles[i].display();
  }
  pos = new float[total][2];
  for ( int j=0; j<pos.length;j++) {
    pos[j][0] = particles[j].xCurr;
    pos[j][1] = particles[j].yCurr;
  }
  delaunay = new Delaunay(pos);
  float[][] edges = delaunay.getEdges();
  for (int i=0; i<edges.length; i++)
  {
    float startX = edges[i][0];
    float startY = edges[i][1];
    float endX = edges[i][2];
    float endY = edges[i][3];
    float trans = 255-dist(startX, startY, endX, endY)*4;
    float sw = 5/(dist(startX, startY, endX, endY)+1);
    strokeWeight(sw);
    stroke(0, trans);
    line(startX, startY, endX, endY);
  }
}

public void keyPressed() {
  if (key =='r') {
    for (int i=0;i<total;i++) {
      particles[i].reset();
    }
  }
}

class Particle {
  float xCurr, yCurr;
  float xInit, yInit;
  float xo,yo;
  Particle(float xo_, float yo_) {
    xo = xo_;
    yo = yo_;
    float degreeTemp = random(360);
    float rTemp = random(10, 200);
    xInit = cos(radians(degreeTemp))*rTemp+xo;
    yInit = sin(radians(degreeTemp))*rTemp+yo;
    xCurr = xInit;
    yCurr = yInit;
  }
  public void update() {
    float x0 = xCurr;
    float y0 = yCurr;
    float a = mouseX-x0;
    float b = mouseY-y0;
    float r = sqrt(a*a+b*b);
    float quer_fugir_x = xCurr-(a/r)*100/r;
    float quer_fugir_y = yCurr-(b/r)*100/r;
    float quer_voltar_x = (xInit-x0)/10;
    float quer_voltar_y = (yInit-y0)/10;
    xCurr = quer_fugir_x+quer_voltar_x;
    yCurr = quer_fugir_y+quer_voltar_y;
  }
  public void display() {
    strokeWeight(1);
    stroke(0);
    point(xCurr, yCurr);
  }
  public void reset() {
    float degreeTemp = random(360);
    float rTemp = random(10, 200);
    xInit = cos(radians(degreeTemp))*rTemp+xo;
    yInit = sin(radians(degreeTemp))*rTemp+yo;
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#EEEEEE", "sketch_oct22a_2011" });
  }
}
