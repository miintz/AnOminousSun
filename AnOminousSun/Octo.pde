/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/43503*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//Raven Kwok (aka Guo Ruiwen)
//oct22a_2011
/*
 
 raystain@gmail.com
 twitter.com/ravenkwok
 flickr.com/ravenkwok
 weibo.com/ravenkwok
 the-moor.blogbus.com
 
 note: Update on Sep.03, 2012. 
 _1. Some modification on the motion of each particle, thanks to Ale( http://www.openprocessing.org/portal/?userID=12899 )'s advice :)
 _2. Each particle now has it own "tensile force". This "force" is indicated by size of the block.
 */

import megamu.mesh.*;

class Octo implements AppletInterface
{
  int count;
  float xOffset, yOffset;
  float [][] pos;
  Particle [] particles;
  Delaunay delaunay;
  
  PImage Mask;
  
  void setup() {
    //size(600, 600, P2D);
    smooth();
    
    Mask = loadImage("mask.png");
    
    rectMode(CENTER);
    count = 2500;
    xOffset = width/4;
    yOffset = height/4;
    particles = new Particle[count];
    for (int i=0; i<count; i++) {
      particles[i] = new Particle(xOffset, yOffset);
    }
  }
  void draw() {

    background(255);
    
    for (int i=0; i<count; i++) {
      particles[i].update();
    }

    pos = new float[count][2];

    for ( int j=0; j<pos.length; j++) {
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
      float distance = dist(startX, startY, endX, endY);
      float trans = 255-map(distance, 0, 60, 0, 255);
      float sw = 2/sqrt(distance+1);
      strokeWeight(sw);
      stroke(0, trans);
      line(startX, startY, endX, endY);
    }

    for (int i=0; i<count; i++) {
      particles[i].display();
    }
    
  }

  void keyReleased()
  {
  }

  void keyPressed() {
    if (key =='r') {
      for (int i=0; i<count; i++) {
        particles[i].reset();
      }
    }
  }

  class Particle {
    float xCurr, yCurr;
    float xInit, yInit;
    float xo, yo;
    
    float pushForce;
    float recoverForce;
    
    Particle(float xo, float yo) {
      this.xo = xo;
      this.yo = yo;

      println(xo, yo);

      float degreeTemp = random(360);
      float rTemp = random(10, 180);
      
      xInit = cos(radians(degreeTemp)) * rTemp + xo;
      yInit = sin(radians(degreeTemp)) * rTemp + yo;
      
      xCurr = xInit;
      yCurr = yInit;
      
      pushForce = random(10, 300);
      recoverForce = random(10, 100);
    }
    void update() {
      float x0 = xCurr;
      float y0 = yCurr;
      
      println(x0, y0);
      
      float a = mouseX - x0;
      float b = mouseY - y0;
      
      float r = (pushForce) / (a*a+b*b);
      
      float quer_fugir_x = xCurr-a*r;
      float quer_fugir_y = yCurr-b*r;
      float quer_voltar_x = (xInit-x0)/recoverForce;
      float quer_voltar_y = (yInit-y0)/recoverForce;
      
      xCurr = quer_fugir_x+quer_voltar_x;
      yCurr = quer_fugir_y+quer_voltar_y;
    }
    void display() {
      pushMatrix();
      translate(xCurr, yCurr);
      rotate(radians(360*noise(xCurr*0.01, yCurr*0.01)));
      float diam = (pushForce/recoverForce)/dist(xCurr, yCurr, mouseX, mouseY)*100;
      strokeWeight(1);
      stroke(0, 100);
      fill(255);
      rect(0, 0, diam, diam);
      popMatrix();
    }
    void reset() {
      float degreeTemp = random(360);
      float rTemp = random(10, 180);
      pushForce = random(10, 300);
      recoverForce = random(10, 100);
      xInit = cos(radians(degreeTemp))*rTemp+xo;
      yInit = sin(radians(degreeTemp))*rTemp+yo;
    }
  }
}

