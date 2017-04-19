import codeanticode.syphon.SyphonServer;
import processing.pdf.*;
import java.util.Calendar;
import netP5.*;
import oscP5.*;



OscP5 osc;
SyphonServer syphon;

boolean savePDF = false;

float tileCount = 20;
color circleColor = color(0);
int circleAlpha = 180;
int actRandomSeed = 0;
int col;
float vX, vY = 100;
PGraphics buffer;

void settings() {
  size(1024, 768, P3D);
  PJOGL.profile=1;
  smooth(8);
}

void setup() { 
  size(960, 540, P3D);
  osc = new OscP5(this, 12345);
  syphon = new SyphonServer( this , "p5-to-syphon" );
} 

int changeBackgroundType = 1;

void draw() {
  
  background(frameCount%255);
  syphon.sendScreen( );
  
  if(changeBackgroundType != -1) {
    if(changeBackgroundType==1) {
      strokeWeight(20);
      background(255);
    } 
    changeBackgroundType = -1;
  }
  
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  translate(width/tileCount/2, height/tileCount/2);

  background(0);
  smooth();
  noFill();
  
  randomSeed(actRandomSeed);

  //stroke(random(0,255),random(0,255),random(0,255));
  stroke(col);
  strokeWeight(vY/60);
  
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {

      float posX = width/tileCount * gridX;
      float posY = height/tileCount * gridY;

      float shiftX = random(-vX, vX)/20;
      float shiftY = random(-vX, vX)/20;

      ellipse(posX+shiftX, posY+shiftY, vY/2, vY/2);
      
      if (key == 'a')
     
      rect(posX+shiftX, posY+shiftY, vY/2, vY/2);
      
     
      
    }
  }
  
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}


void keyReleased(){
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'p' || key == 'P') savePDF = true;
}

void oscEvent(OscMessage m) {
  println(m);
  if(m.addrPattern().equals("/bangs")) {
    
    col = (int) random(100000);
    
  } 
  else if(m.addrPattern().equals("/myColor")) {
    
    int r = m.get(0).intValue();
    int g = m.get(1).intValue();
    int b = m.get(2).intValue();
    col = color(r,g,b);
    
  } 
  else if(m.addrPattern().equals("/curves")) {
    
    vX = m.get(0).floatValue() * 10009;
    
  } 
  else if(m.addrPattern().equals("/bangsBack")) {
    changeBackgroundType = 1;
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
