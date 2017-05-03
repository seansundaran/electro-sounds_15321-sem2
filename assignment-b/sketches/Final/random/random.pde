
import processing.pdf.*;
import java.util.Calendar;
import codeanticode.syphon.SyphonServer;
import netP5.*;
import oscP5.*;

OscP5 osc;
SyphonServer syphon;

boolean savePDF = false;

int pointCount = 500;
int freqX = 1;
int freqY = 4;
float phi = 60;

int modFreqX = 2;
int modFreqY = 1;
float modulationPhi = 0;

float angle;
float x, y; 
float w, maxDist;
float oldX, oldY;

int drawMode = 2;

void settings() {
  size(1024, 768, P3D);
  PJOGL.profile=1;
  smooth(8);
}


void setup() {
  size(960, 540, P3D);
  smooth();
  strokeCap(ROUND);

  maxDist = sqrt(sq(width/2-50) + sq(height/2-50));
  osc = new OscP5(this, 12345);
  syphon = new SyphonServer( this, "p5-to-syphon" );
}


void draw() {
  // if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  if (savePDF) beginRecord(PDF, freqX+"_"+freqY+"_"+int(phi)+"_"+modFreqX+"_"+modFreqY+".pdf");

  background(255);
  syphon.sendScreen( );

  translate(width/2, height/2);

  pointCount = mouseX*2+200;

  if (drawMode == 1) {
    stroke(0);
    strokeWeight(10);
    background(0);

    beginShape();
    for (int i=0; i<=pointCount; i++){
      angle = map(i, 0,pointCount, 0,TWO_PI);

      x = sin(angle * freqX + radians(phi)) * cos(angle * modFreqX);
      y = sin(angle * freqY) * cos(angle * modFreqY);

      x = x * (width/2-50);
      y = y * (height/2-50);

      vertex(x, y);
    }
    endShape();

  } 
  else if (drawMode == 2) {
    strokeWeight(10);

    for (int i=0; i<=pointCount; i++){
      angle = map(i, 0,pointCount, 0,TWO_PI);

      // amplitude modulation
      x = sin(angle * freqX + radians(phi)) * cos(angle * modFreqX);
      y = sin(angle * freqY) * cos(angle * modFreqY);

      x = x * (width/2-50);
      y = y * (height/2-50);

      if (i > 0) {
        w = dist(x, y, 0, 0);
        float lineAlpha = map(w, 0,maxDist, 255,0);
        stroke(i%2*2, lineAlpha);
        line(oldX, oldY, x, y);
      }

      oldX = x;
      oldY = y;
    }
  }


  if (savePDF) {
    savePDF = false;
    println("saving to pdf – finishing");
    endRecord();
  }
}



void keyPressed(){
  if(key == 's' || key == 'S') saveFrame(timestamp()+".png");
  if(key == 'p' || key == 'P') {
    savePDF = true; 
    println("saving to pdf - starting");
  }

  if (key=='d' || key=='D') {
    if (drawMode == 1) drawMode = 2;
    else drawMode = 1;
  }

  if(key == '1') freqX--;
  if(key == '2') freqX++;
  freqX = max(freqX, 1);

  if(key == '3') freqY--;
  if(key == '4') freqY++;
  freqY = max(freqY, 1);

  if (keyCode == LEFT) phi -= 15;
  if (keyCode == RIGHT) phi += 15;
  
  if(key == '7') modFreqX--;
  if(key == '8') modFreqX++;
  modFreqX = max(modFreqX, 1);
  
  if(key == '9') modFreqY--;
  if(key == '0') modFreqY++;
  modFreqY = max(modFreqY, 1);
  
  println("freqX: " + freqX + ", freqY: " + freqY + ", phi: " + phi + ", modFreqX: " + modFreqX + ", modFreqY: " + modFreqY); 
}


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}