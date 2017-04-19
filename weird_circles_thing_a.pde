 import codeanticode.syphon.SyphonServer;
import processing.pdf.*;
import java.util.Calendar;
import netP5.*;
import oscP5.*;

OscP5 osc;
SyphonServer syphon;

boolean recordPDF = false;

int formResolution = 15;
int stepSize = 2;
float distortionFactor = 1;
float initRadius = 150;
float centerX, centerY;
float[] x = new float[formResolution];
float[] y = new float[formResolution];
float vX = 1;
float vY = 1;


boolean filled = false;
boolean freeze = false;

void settings() {
  size(1024, 768, P3D);
  PJOGL.profile=1;
  smooth(8);
}

void setup() {
  size(960, 540, P3D);
  osc = new OscP5(this, 12345);
  syphon = new SyphonServer( this , "p5-to-syphon" );


  // init form
  centerX = width/2; 
  centerY = height/2;
  float angle = radians(360/float(formResolution));
  for (int i=0; i<formResolution; i++) {
    x[i] = cos(angle*i) * initRadius;
    y[i] = sin(angle*i) * initRadius;
    background(255);
  }
}


int changeBackgroundType = 0;

void draw() {
  
  
  syphon.sendScreen( );
  
  if(changeBackgroundType != -1) {
    if(changeBackgroundType==1) {
      stroke(0);
      background(255);
    } else if(changeBackgroundType == 2) {
      stroke(255);
      background(0);
    }
    else if(changeBackgroundType == 3) {
      
      background(random(230,255),random(0,45),random(0,100));
    }
    changeBackgroundType = -1;
  }


  // floating towards mouse position
  if (vX != 0 || vY != 0) {
    centerX += (vX-centerX) * 0.01;
    centerY += (vY-centerY) * 0.01;
  }

  // calculate new points
  for (int i=0; i<formResolution; i++) {
    x[i] += random(-stepSize, stepSize);
    y[i] += random(-stepSize, stepSize);
    // ellipse(x[i], y[i], 5, 5);
  }

  strokeWeight(0.5);
  if (filled) fill(random(255), random(255), random(255));
  else noFill();

  beginShape();
  // start controlpoint
  curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);

  // only these points are drawn
  for (int i=0; i<formResolution; i++) {
    curveVertex(x[i]+centerX, y[i]+centerY);
  }
  curveVertex(x[0]+centerX, y[0]+centerY);

  // end controlpoint
  curveVertex(x[1]+centerX, y[1]+centerY);
  endShape();
}



void oscEvent(OscMessage m) {
  println(m);
  if (m.addrPattern().equals("/curves_X")) {

    vX = m.get(0).floatValue() * 5000;
  } else if (m.addrPattern().equals("/curves_Y")) {

    vY = m.get(0).floatValue() * 5000;
  } else if (m.addrPattern().equals("/black")) 
  {    
    changeBackgroundType = 1;
    filled = false;
  } else if (m.addrPattern().equals("/white")) 

  {   
    changeBackgroundType = 2;
    filled = false;
  } else if (m.addrPattern().equals("/color")) 

  { 
    changeBackgroundType = 3;
    filled = true;
  }
}