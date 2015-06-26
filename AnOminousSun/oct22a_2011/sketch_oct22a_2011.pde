//Raven Kwok | 郭锐文
//Email: raystain@gmail.com
//Blog: the-moor.blogbus.com
//Vimeo: vimeo.com/ravenkwok
//Weibo: weibo.com/ravenkwok
 
import megamu.mesh.*;

int total;
float xOffset, yOffset;
float [][] pos;
Particle [] particles;
Delaunay delaunay;

void setup() {
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
void draw() {
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

void keyPressed() {
  if (key =='r') {
    for (int i=0;i<total;i++) {
      particles[i].reset();
    }
  }
}

