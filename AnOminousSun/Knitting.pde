class Knitting implements AppletInterface
{
  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/31404*@* */
  /* !do not delete the line above, required for linking your tweak if you upload again */
  /*
  
   pixel knitting 
   (c) Pierre Commenge / emoc*codelab.fr
   27 juillet 2011
   
   feed with fresh pictures only!
   (uncomment at the end of draw() to save frames)
   */
  
  // Free software: you can redistribute this program and/or modify
  // it under the terms of the GNU General Public License as published by
  // the Free Software Foundation, either version 3 of the License, or
  // (at your option) any later version.
  
  PImage img;
  PImage Mask;
  
  int i;
  
  String ts;
  
  boolean first = true;  
  boolean enabled = false;  
  boolean MODIFY_ANGLE = true;
  
  // parameters (play here)
  float ANGLE_SEED = 13;     // 13 / 257 / 77
  float amod = ANGLE_SEED;
  float amod_inc = 0.5; // angle change for a new line
  float smod = 0.7; // size modifier
  float im, imax, imin;
  float lasty, x, y;
  
  void setup() {
    img = loadImage("img_18b.jpg");

    Mask = loadImage("mask.png");
    
    //size(img.width, img.height);     
    imax = img.width * img.height;
    imin = 0;
    
    background(255);
    smooth();
  }
  
  void draw() {
    if (enabled)
    {        
      if (first) {
        image(img, 0, 0);
        first = false;
      }
  
      img.loadPixels();
      im += 1000;
  
      if (im > imax) im = imax;
  
      int Cx = width / 2;
      int Cy = height / 2;
  
      int radius = width / 2;
      
      for (i = int (imin); i < im; i++) 
      {   
        x = i%img.width;
        y = floor(i/img.width);
        
        if (MODIFY_ANGLE && (lasty != y)) amod += amod_inc;
  
        color cc = img.pixels[i]; 
  
        stroke(cc);
        fill(cc);
  
        float bri = brightness(img.pixels[i]);
        float sat = saturation(img.pixels[i]);
        
        if (pow((x - Cx), 2) + pow((y - Cy), 2) < pow(radius, 2))
        {
          if (bri > 245) 
            draw_lines(bri, x, y, amod - x/3, smod);
          else if (bri < 10) 
            draw_lines_dark(bri, x, y, amod - x/3, smod);
          else {
            strokeWeight(sat / 15); 
    
            float a = (360.0 / 255.0) * sat + amod; 
            float x2 = x + bri/4 * random(0.7, 1) * smod * cos(radians(a)); 
            float y2 = y + bri/4 * random(0.7, 1) * smod * sin(radians(a));
    
            line(x, y, x2, y2);
          }
          if ((sat > 200) && (bri > 150))       
            draw_circle(sat, x, y, amod, smod);
        }
        lasty = y;
      }
  
      imin = im;
  
      if (im == imax) {
        // saveFrame("image_" + hour() + minute() + second() + ".png"); // UNCOMMENT ! NO!!
        noLoop();
      }
    }
    
    image(Mask, 0, 0);
    
  }
  
  void keyPressed()
  {    
    if (keyCode == 82)
    {      
      first = true;
      im = 0;
    }  
  
    if (keyCode == 69)
    {       
      if (!enabled)
        enabled = true;
      //else
        //enabled = false;
    }
  }
  
  void keyReleased()
  {
  }
  
  void draw_lines(float s, float x, float y, float amod, float smod) {
    int im = int((s - 245) / 5);
    for (int i=0; i < im; i++) {
      float b = random(amod, amod+90);
      float l = im * random(10 * smod, 40 * smod);
      float x2 = x + l * cos(radians(b));
      float y2 = y + l * sin(radians(b));
      strokeWeight(( 1 - (0.5 * im)) * smod);
      line(x, y, x2, y2);
    }
  }
  
  void draw_lines_dark(float s, float x, float y, float amod, float smod) {
    int im = int(s / 2);
    for (int i=0; i < im; i++) {
      float b = random(amod, amod+90);
      float l = im * random(10 * smod, 40 * smod);
      float x2 = x + l * cos(radians(b));
      float y2 = y + l * sin(radians(b));
      strokeWeight(( 1 - (0.2 * im)) * smod);
      line(x, y, x2, y2);
    }
  }
  
  void draw_circle(float s, float x, float y, float amod, float smod) {
    float dia = random(s / 50) * smod;
    float ll = random(s / 3.0) * smod;
    float ang = random(360); 
    float x2 = x + ll * cos(radians(ang));
    float y2 = y + ll * sin(radians(ang));
    strokeWeight(1);
    ellipse(x2, y2, dia, dia);
  }

}
