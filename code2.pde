import codeanticode.syphon.SyphonServer;
import processing.pdf.*;
import java.util.Calendar;
import netP5.*;
import oscP5.*;

OscP5 osc;
SyphonServer syphon;

boolean savePDF = false;

float tileCountX = 5;
float tileCountY = 5;
float curvesX = 0.1;
float curvesY = 0.1;

int count = 10;
int colorStep = 20;

int lineWeight = 0;
int strokeColor = 0;

color backgroundColor = 255;

int drawMode = 1;

void settings() {
  size(1024, 768, P3D);
  PJOGL.profile=1;
  smooth(8);
}
void setup() { 
  size(960, 540, P3D);
  osc = new OscP5(this, 12345);
  syphon = new SyphonServer( this, "p5-to-syphon" );
} 

void draw() { 

  background(frameCount%255);
  syphon.sendScreen( );

  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  colorMode(HSB, 360, 100, 100); 
  strokeWeight(0.5);
  strokeCap(ROUND);

  tileCountX = curvesX/30+1;
  tileCountY = curvesY/30+1;

  background(backgroundColor);

  for (int gridY=0; gridY<= tileCountY; gridY++) {
    for (int gridX=0; gridX<= tileCountX; gridX++) {  

      float tileWidth = width/tileCountX;
      float tileHeight = height/tileCountY;
      float posX = tileWidth*gridX;
      float posY = tileHeight*gridY;

      float x1 = tileWidth/2;
      float y1 = tileHeight/2;
      float x2 = 0;
      float y2 = 0;

      pushMatrix();
      translate(posX, posY);

      for (int side = 0; side < 4; side++) {
        for (int i=0; i< count; i++) {

          // move end point around the four sides of the tile
          if (side == 0) {     
            x2 += tileWidth/count;
            y2 = 0;
          }
          if (side == 1) {     
            x2 = tileWidth;
            y2 += tileHeight/count;
          }
          if (side == 2) {     
            x2 -= tileWidth/count;
            y2 = tileHeight;
          }
          if (side == 3) {     
            x2 = 0;
            y2 -= tileHeight/count;
          }

          // adjust weight and color of the line
          if (i < count/2) {
            lineWeight += 1;
            strokeColor += 60;
          } else {
            lineWeight -= 1;
            strokeColor -= 60;
          }

          // set colors depending on draw mode
          switch(drawMode) {
          case 1:
            backgroundColor = 0;
            stroke(255, random(0, 255), random(0, 255));
            break;
          case 2:
            backgroundColor = 360;
            stroke(random(0, 255), 255, 255);
            strokeWeight(lineWeight);
            break;
          case 3:
            backgroundColor = 0;
            stroke(random(0, 255), random(0, 255));
            strokeWeight(mouseX/50);
            break;
          case 4:
            backgroundColor = 360;
            stroke(255,random(0,1), random(0,50));
            strokeWeight(lineWeight);
            break;
          }

          // draw the line
          line(x1, y1, x2, y2);
        }
      }

      popMatrix();
    }
  }

  if (savePDF) {
    savePDF = false;
    endRecord();
  }
} 


void oscEvent(OscMessage m) {
  println(m);
  if (m.addrPattern().equals("/bangs_1")) {
    drawMode = 1;
  } else if (m.addrPattern().equals("/bangs_2")) {
    drawMode = 2;
  } else if (m.addrPattern().equals("/bangs_3")) {
    drawMode = 3;
  } else if (m.addrPattern().equals("/bangs_4")) {
    drawMode = 4;
  } else if (m.addrPattern().equals("/curves_x")) {

    curvesX = m.get(0).floatValue() * 10009;
  } else if (m.addrPattern().equals("/curves_y")) {

    curvesY = m.get(0).floatValue() * 10009;
  }
} 

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
