/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/33444*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//         Multi-Level Multi-Color Turing-McCabe Pattern Explorer          //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

// (c) bit.craft 2011

// Turing-McCabe patterns are based on a  multi-layer single-chemical reaction-diffusion system,
// as first described by Jonathan Mc Cabe [1]

// This code extends upon the very efficient implementation posted by Kyle McDonald [2]
// The basic algorithm for Turing-McCabe Patterns was detailled by Jason Rampe [3]
// and first implemented in Processing by Frederik Vanhoutte [4]

// [1] http://www.jonathanmccabe.com/Cyclic_Symmetric_Multi-Scale_Turing_Patterns.pdf
// [2] http://www.openprocessing.org/visuals/?visualID=31195
// [3] http://softologyblog.wordpress.com/2011/07/05/multi-scale-turing-patterns/
// [4] http://www.wblut.com/2011/07/13/mccabeism-turning-noise-into-a-thing-of-beauty/

import controlP5.*;

class McCabe implements AppletInterface
{
  ControlP5 controlP5;
  CheckBox checkbox;
  RadioButton radio;
  Textlabel label;
  Slider slider;
  
  PImage Mask;
  
  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  final static int RESOLUTION = 1, SYMMETRY = 2, OPTIONS = 3, BRUSH = 4;
  final static int STEP_OFFSET = 5, STEP_SCALE = 6, COLOR_OFFSET = 7, BLUR_LEVEL = 8;
  final static int OPT_COLOR = 0, OPT_INVERT = 1;

  boolean isInit, isUpdate;

  int imgWidth, imgHeight;
  int id;
  int cx, cy;
  int ygap = 36;
  int controlWidth = 98;

  boolean colMode = true;
  boolean invertMode = false;
  int resolution = 2;
  int spacing = 20;
  int brush = 2;
  float stepOffsetMin = .001;
  float stepOffsetMax = .2;
  float stepScaleMin = .001;
  float stepScaleMax = .1;
  
  PApplet that;
  
  void setup() {
    //size(800, 500, P2D);
    //size(720, 600, P2D);
    Mask = loadImage("mask.png");
    resetParams();
    //setupControls(); hier gaat het mis mee (nullpointer oid) ik heb deze toch niet echt nodig
    updateControls();
    
    colorMode(HSB);
  }

  void draw() {
    
    symmetry();
    calculatePattern();
    
    background(255);
    
    renderPattern(buffer);
    drawImage(buffer);
    
    //drawControls();
    interaction();  
    // if(frameCount % 20 == 0) frameRate);
    
    image(Mask, 0,0);
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                                                         //
  //                            ControlP5 based GUI                          //
  //                                                                         //
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////// draw ////////////////////////////////////////

  void drawControls() {
    controlP5.draw();
  }

  void drawImage(PImage img) {
    //pushMatrix();
    //translate(spacing, spacing);
    noFill();
    stroke(0);
    //rect(-1, -1, imgWidth+1, imgHeight+1);
    image(img, 0, 0, width, height);
    filter(GRAY);
    //popMatrix();
  }

  ////////////////////////////// setup ////////////////////////////////////////

  void setupControls() {

    isInit = false;
    controlP5 = new ControlP5(that);

    cx = imgWidth + 2 * spacing;
    cy = spacing;

    // custom color scheme
    controlP5.setColorActive(140);
    controlP5.setColorBackground(220);
    controlP5.setColorLabel(0);
    controlP5.setColorForeground(190);

    setupResolutionControl();
    setupSymmetryControl();
    setupOptionsControl();
    setupParamsControl();
    setupBrushControl();

    isInit = true;
  }

  void setupResolutionControl() {
    heading("RESOLUTION");
    radio = controlP5.addRadioButton("resolution", cx, cy);
    radio.setNoneSelectedAllowed(false);
    radio.setId(RESOLUTION);
    radio.setItemsPerRow(3);
    radio.setSpacingColumn(40);
    radio.addItem("resolution2", 2).setLabel("lores");
    radio.addItem("resolution1", 1).setLabel("hires");
    cy += ygap;
  }

  void setupSymmetryControl() {
    heading("SYMMETRY");
    radio = controlP5.addRadioButton("symmetry", cx, cy);
    radio.setNoneSelectedAllowed(false);
    radio.setId(SYMMETRY);
    radio.setItemsPerRow(3);
    radio.setSpacingColumn(12);
    radio.setSpacingRow(10);
    radio.setItemHeight(20);
    radio.setItemWidth(20);
    for (int i=0; i<=6; i++) {
      if (i==1) continue;
      
      //radio.addItem("symmetry" + i, i).setDisplay(new PieDisplay(20, i));
    }
    cy += 40 + ygap;
  }

  void setupOptionsControl() {
    heading("OPTIONS");
    checkbox = controlP5.addCheckBox("options", cx, cy);
    checkbox.setId(OPTIONS);
    checkbox.setItemsPerRow(2);
    checkbox.setSpacingColumn(40);
    checkbox.setSpacingRow(10);
    checkbox.addItem("color", OPT_COLOR);
    checkbox.addItem("invert", OPT_INVERT);
    cy += ygap;
  }

  void setupParamsControl() {
    heading("PARAMS");
    cy += 5;
    makeSlider("step offset").setId(STEP_OFFSET);
    makeSlider("step scale").setId(STEP_SCALE);
    makeSlider("diffusion").setId(BLUR_LEVEL);
    slider = makeSlider("color offset");
    slider.setId(COLOR_OFFSET);
    slider.setLabel("color");
    cy += ygap/2;
  }

  void setupBrushControl() {
    heading("BRUSH"); 
    radio = controlP5.addRadioButton("brush", cx, cy);
    radio.activateEvent(false);
    radio.setNoneSelectedAllowed(false);
    radio.setId(BRUSH);
    radio.setItemsPerRow(4);
    radio.setSpacingColumn(10);
    radio.setItemHeight(20);
    radio.setItemWidth(20);
    for (int i=3; i>=1; i--) {
      
      //radio.addItem("brush" + i, i).setDisplay(new PieDisplay((1+i)*5));
    } 
    cy += ygap;
  }


  ////////////////////////////// update ///////////////////////////////////////

  // mapping: params ==> controls

  void updateControls() {
    if (isInit) {
      isUpdate = false;
      updateResolutionControl();
      updateSymmetryControl();
      updateOptionsControl();
      updateParamsControl();
      updateBrushControl();
      isUpdate = true;
    }
  } 

  void updateResolutionControl() {
    getRadioButton("resolution").activate("resolution" + resolution);
  }

  void updateSymmetryControl() {
    getRadioButton("symmetry").activate("symmetry" + symmetry);
  }

  void updateParamsControl() {
    updateSlider("step offset", stepOffsetMin, stepOffsetMax, stepOffset);
    updateSlider("step scale", stepScaleMin, stepScaleMax, stepScale);
    updateSlider("color offset", 0, 255, colorOffset);
    updateSlider("diffusion", 0, 1, blurFactor);
  }

  void updateOptionsControl() {
    checkbox = getCheckBox("options");
    getToggle("color").setValue(colMode);
    getToggle("invert").setValue(invertMode);
  }

  void updateBrushControl() {
    getRadioButton("brush").activate("brush" + brush);
  }


  /////////////////////////////// events ///////////////////////////////////////

  //  mapping: controls ==> params

  void controlEvent(ControlEvent theEvent) {


    // ignore events triggered during setup
    if (!isInit || !isUpdate) return;

    // all other events are handled via their type and ID
    int val, id, type = theEvent.type();

    switch ( type ) {

    case GROUP:

      ControlGroup theGroup = theEvent.group();
      // println("group "+theGroup.name());
      val = (int) theGroup.value();
      id = theGroup.id();

      switch ( id ) {

      case SYMMETRY:
        symmetry = val;
        resetParams();
        break;

      case BRUSH:
        brush = val;
        break;

      case OPTIONS: 
        boolean[] opts = toBoolean(theGroup.arrayValue());
        colMode = opts[OPT_COLOR];
        invertMode = opts[OPT_INVERT];
        break;

      case RESOLUTION:
        resolution = val;
        resetParams();
        break;
      }
      break;

    case CONTROLLER:

      Controller theController = theEvent.controller();
      // println("controller "+ theController.name());
      val = (int) theController.value();
      id = theController.id();

      switch ( id ) {

      case COLOR_OFFSET:
        colorOffset = (int) map(val, 0, 100, 0, 255);
        break;

      case STEP_SCALE:
        stepScale = map(val, 0, 100, stepScaleMin, stepScaleMax);
        updateParams();
        break;

      case STEP_OFFSET:
        stepOffset = map(val, 0, 100, stepOffsetMin, stepOffsetMax);
        updateParams();
        break;

      case BLUR_LEVEL:
        blurFactor = map(val, 0, 100, 0, 1);
        updateParams();
        break;
      }

      break;
    }
  }


  ////////////////////////// helper functions //////////////////////////////////

  RadioButton getRadioButton(String name) {
    return (RadioButton) controlP5.group(name);
  }

  CheckBox getCheckBox(String name) {
    return (CheckBox) controlP5.group(name);
  }

  Slider getSlider(String name) {
    return (Slider) controlP5.controller(name);
  }

  Toggle getToggle(String name) {
    return (Toggle) controlP5.controller(name);
  }

  void heading(String str) {
    label = controlP5.addTextlabel("heading" + id++, str, cx, cy);
    label.setFont(controlP5.grixel);
    label.setColorValue(0);
    label.setLetterSpacing(2);
    label.setWidth(controlWidth);
    cy += ygap / 2;
  }

  Slider makeSlider(String name) {
    cy += 11;
    slider = controlP5.addSlider(name, 0, 100, 50, cx, cy, 100, 12);
    slider.setDecimalPrecision(0);
    slider.captionLabel().style().moveMargin(-15, 0, 0, -103);
    cy += 22;
    return slider;
  }

  void updateSlider(String name, float vmin, float vmax, float val) {
    getSlider(name).setValue((int) map(val, vmin, vmax, 0, 100));
  }

  boolean[] toBoolean(float[] a) {
    boolean[] a2 = new boolean[a.length];
    for (int i = 0; i < a.length; i++) a2[i] = (a[i] == 1);
    return a2;
  }


  /////////////////////////////////////////////////////////////////////////////
  //                                                                         //
  //           Fast Diffusion Algorithm for Turing Patterns                  //
  //                                                                         //
  /////////////////////////////////////////////////////////////////////////////


  void blur(float[] from, float[] buffer, int w, int h) {
    for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
      int i = y * w + x;
      int E = x > 0 ? - 1 : 0;
      int N = y > 0 ? - w : 0;
      buffer[i] = buffer[i+N] + buffer[i+E] - buffer[i+N+E] + from[i];
    }
  }

  void collect(float to[], float[] buffer, int w, int h, int radius) {
    for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
      int minx = max(0, x - radius);
      int maxx = min(x + radius, w - 1);
      int miny = max(0, y - radius);
      int maxy = min(y + radius, h - 1);
      int area = (maxx - minx) * (maxy - miny);
      to[y * w + x] = (buffer[maxy * w + maxx] - buffer[maxy * w + minx] - buffer[ miny * w + maxx] + buffer[miny * w + minx]) / area;
    }
  }


  /////////////////////////////////////////////////////////////////////////////
  //                                                                         //
  //                     Mouse and Keyboard Interaction                      //
  //                                                                         //
  /////////////////////////////////////////////////////////////////////////////


  ////////////////////////// mouse interaction ////////////////////////////////

  int imgMouseX, imgMouseY;
  boolean drawing;

  void interaction() {
    // interaction inside the image
    imgMouseX = mouseX - spacing;
    imgMouseY = mouseY - spacing;
    cursor (drawing ? CROSS : ARROW);
    if (mousePressed) mouseDown();
  }

  boolean insideImage() {
    return imgMouseX>0 && imgMouseX < imgWidth && imgMouseY > 0 && imgMouseY < imgHeight;
  }

  void mousePressed() {
    if (mouseButton!=CENTER) {
      drawing = insideImage();
    }
  }

  void mouseReleased() {
    drawing = false;
  }

  void mouseDragged() {
    if (mouseButton==CENTER) {
      colorOffset += 256 * (dist(pmouseX, pmouseY, mouseX, mouseY) / width);
    }
  }

  void mouseDown() {

    // add a circular drop of chemical

    if (drawing && mouseButton != CENTER) {
      int x0 = imgMouseX / resolution;
      int y0 = imgMouseY / resolution;
      int brushIndex = levels - 4 + constrain(brush, 1, 3);
      int r = radii[brushIndex] / resolution;
      int xmin = max(0, x0-r), xmax = min(w, x0+r);
      int ymin = max(0, y0-r), ymax = min(h, y0+r);
      for (int y = ymin; y < ymax; y++) for (int x = xmin; x < xmax; x++) {
        if (dist(x, y, x0, y0) < r)
          grid[x + w*y] = mouseButton == LEFT ? gmax : gmin;
      }
    }
  }


  ////////////////////////// keyboard interaction /////////////////////////////
    
  void keyReleased()
  {}  
  
  void keyPressed() {      
    
    switch(keyCode)
    {
      case 72:
        randomizeParams();
        break;
      case 76:
        resolution = 4;
        resetParams(); 
      break;
      case 75: //kwart resolution
        resolution = 2;
        resetParams(); 
      break;
      case 74: //h
        resolution = 1;
        resetParams(); 
      break;
    }
      
    switch( key ) {

    case ' ': 
      resetParams(true); 
      break;

    case 'c': 
      colMode = !colMode; 
      break;
    case 'i': 
      invertMode = !invertMode; 
      break;

    case 'l': 
      resolution = 2; 
      resetParams(); 
      break;
    case 'h': 
    println("H");
      resolution = 1; 
      resetParams(); 
      break;

    case '+': 
      brush = min(3, brush+1); 
      break;
    case '-': 
      brush = max(1, brush-1); 
      break;


    case 'q': 
      stepOffset += .001; 
      break;
    case 'w': 
      stepScale += .001; 
      break;
    case 'e': 
      blurFactor += .01; 
      break; 
    case 'r': 
      colorOffset =  (colorOffset + 1) % 256; 
      break;

    case 'a': 
      stepOffset -= .001; 
      break;
    case 's': 
      stepScale -= .001; 
      break;
    case 'd': 
      blurFactor -= .01; 
      break;
    case 'f': 
      colorOffset = (colorOffset + 256 - 1) % 256; 
      break;

    default:
      // select symmetry via number keys
      if (key>='0' && key <= '6') {
        symmetry = key - '0';
        if (symmetry == 1) symmetry = 0;
        resetParams();
      } else return;
    }

    stepScale = constrain(stepScale, stepScaleMin, stepScaleMax);
    stepOffset = constrain(stepOffset, stepOffsetMin, stepOffsetMax);
    blurFactor = constrain(blurFactor, 0, 1);

    updateParams(); 
    //updateControls();
  }


  /////////////////////////////////////////////////////////////////////////////
  //                                                                         //
  //      Parameters for the Multi-Color Multi-Level Turing Pattern          //
  //                                                                         //
  /////////////////////////////////////////////////////////////////////////////

  int w, h, n, levels, blurlevels;
  float gridmin, gridmax, colormax, colormin;

  float[] grid, colorgrid, bestVariation;
  float[] diffusionLeft, diffusionRight, blurBuffer;
  float[] stepSizes, colorShift;
  boolean[] direction;
  int[] bestLevel, radii;
  PImage buffer;

  // independent params

  float base = 2.0;
  float stepScale = .01;
  float stepOffset = .01;
  float blurFactor = 1.0;
  int symmetry = 0;
  int colorOffset = 0;




  void resetParams() {
    resetParams(false);
  }

  void resetParams(boolean randomize) {

    // set resolution; 
    imgWidth = (width - controlWidth - 3 * spacing) ;
    imgHeight = (height - 2 * spacing);  
    
    //dit moet hele scherm zijn
    w = /*imgWidth*/ height / resolution;
    h = /*imgHeight*/ width / resolution;

    // allocate space
    n = w * h;
    
    grid = new float[n];
    diffusionLeft = new float[n];
    diffusionRight = new float[n];
    blurBuffer = new float[n];
    bestVariation = new float[n];
    bestLevel = new int[n];
    direction = new boolean[n];
    colorgrid = new float[n];
    buffer = createImage(w, h, RGB);

    // initialize the grid with noise
    for (int i = 0; i < n; i++) {
      grid[i] = random(-1, +1);
    }

    // initialize pattern params
    if (randomize) randomizeParams();
    updateParams();
  }

  void randomizeParams() {

    // relates to the complexity (how many blur levels)
    base = random(1.5, 2.4); 

    // these values affect how fast the image changes
    stepScale = random(stepScaleMin, stepScaleMax / 5);
    stepOffset = random(stepOffsetMin, stepOffsetMax / 5);

    // color scheme of the image
    colorOffset = (int) random(255);

    // rotational symmetry groups
    symmetry = int(random(.5, 6.5));
    if (symmetry==1) symmetry = 0;

    // random shape blurring
    blurFactor = random(0.5, 1.0);
  }


  void updateParams() {

    // updating the dependent variables

      levels = (int) (log(max(w, h)) / log(base)) - 1;
    blurlevels = (int) max(0, (levels+1) * blurFactor - .5);

    radii = new int[levels];
    stepSizes = new float[levels];
    colorShift = new float[levels];

    for (int i = 0; i < levels; i++) {
      int radius = (int) pow(base, i);
      radii[i] = radius;
      stepSizes[i] = log(radius) * stepScale + stepOffset;
      colorShift[i] = (i % 2 == 0 ? -1.0 : 1.0) * (levels-i);
    }
  }


  /////////////////////////////////////////////////////////////////////////////
  //                                                                         //
  //     Algorithm for the Multi-Color Multi-Level Turing Pattern            //
  //                                                                         //
  /////////////////////////////////////////////////////////////////////////////

  int gmin, gmax;

  void calculatePattern() {

    float[] source = grid;
    float[] target = diffusionRight;

    for (int level = 0; level < levels; level++) {

      // diffuse chemical to the target layer
      int radius = radii[level]; 
      if (level <= blurlevels) blur(source, blurBuffer, w, h);
      collect(target, blurBuffer, w, h, radius);

      // check/save bestLevel and bestVariation
      for (int i = 0; i < n; i++) {
        float variation = abs(source[i] - target[i]);
        if (level == 0 || variation < bestVariation[i]) {
          bestVariation[i] = variation;
          bestLevel[i] = level;
          direction[i] = source[i] > target[i];
        }
      }

      // update diffusion matrices
      if (level==0) {
        source = target;
        target = diffusionLeft;
      } else {
        float[] swap = source;
        source = target;
        target = swap;
      }
    }

    // update grid from bestLevel
    gridmin = colormin = MAX_FLOAT;
    gridmax = colormax = MIN_FLOAT;
    for (int i = 0; i < n; i++) {
      float curStep = stepSizes[bestLevel[i]];
      if (direction[i]) {
        grid[i] += curStep;
        colorgrid[i] += curStep * colorShift[bestLevel[i]];
      } else {
        grid[i] -= curStep;
        colorgrid[i] -= curStep * colorShift[bestLevel[i]];
      }
      gridmin = min(gridmin, grid[i]);
      gridmax = max(gridmax, grid[i]);
      colormin = min(colormin, colorgrid[i]);
      colormax = max(colormax, colorgrid[i]);
    }

    // normalize to [-1, +1]
    float range = (gridmax - gridmin) / 2;
    float colorrange = (colormax - colormin) / 2;
    for (int i = 0; i < n; i++) {
      grid[i] = ((grid[i] - gridmin) / range) - 1;
      colorgrid[i] = ((colorgrid[i] - colormin) / colorrange) - 1;
    }
  }


  void renderPattern(PImage img) {
    img.loadPixels();
    
    color[] pixels = buffer.pixels;
    
    gmin = invertMode ? -1 : +1;
    gmax = invertMode ? +1 : -1;
    
    int Y = 0;
    
    //cirkel...
    int y = 0;
    int x = 0;

    int Cx = (width / 2) / resolution;
    int Cy = (height / 2) / resolution;

    int radius = ((width / 2) / resolution) + 25;
    
    for (int i = 0; i < n; i++) {

      if (i < width / resolution)     
        y = 0;
      else
        y = ceil(i / (width / resolution));

      x = i % (width / resolution); 
   
      //HBS kleuren
      float h = int(map(colorgrid[i], gmin, gmax, 0, 127) + colorOffset)  % 256;
      float b = map(grid[i], gmin, gmax, 0, 255);
      float s = (255-b) / 2;
      
      //niet doen als het niet in de cirkel zit. 
      if (pow((x - Cx), 2) + pow((y - Cy), 2) < pow(radius, 2))
        pixels[i] = colMode ? color(h, s, b) : color(b);
      else
        pixels[i] = color(0);
        
    }
    
    img.updatePixels();
  }


  /////////////////////////////////////////////////////////////////////////////
  //                                                                         //
  //    Quick Symmetry mapping - for incremental rotational symmetery        //
  //                                                                         //
  /////////////////////////////////////////////////////////////////////////////

  float[] sinus = { 
    0, sin(TWO_PI/1), sin(TWO_PI/2), sin(TWO_PI/3), sin(TWO_PI/4), sin(TWO_PI/5), sin(TWO_PI/6)
  };
  float[] cosinus = { 
    0, cos(TWO_PI/1), cos(TWO_PI/2), cos(TWO_PI/3), cos(TWO_PI/4), cos(TWO_PI/5), cos(TWO_PI/6)
  };

  int getSymmetry(int i, int w, int h) {
    if (symmetry <= 1) return i;
    if (symmetry == 2) return n - 1 - i;
    int x1 = i % w;
    int y1 = i / w;
    float dx = x1 - w/2;
    float dy = y1 - h/2;
    int x2 = w/2 + (int)(dx * cosinus[symmetry] + dy * sinus[symmetry]);
    int y2 = h/2 + (int)(dx * -sinus[symmetry] + dy * cosinus[symmetry]);
    int j = x2 + y2 * w;
    return j<0 ? j+n : j>=n ? j-n : j;
  }


  void symmetry() {
    if (symmetry <=1) return;
    for (int i = 0; i < n; i++) {
      grid[i] = grid[i] * .9 + grid[getSymmetry(i, w, h)] * .1;
    }
  }
}

