
import processing.pdf.*;
import java.util.Calendar;

boolean savePDF = false;

float tileCount = 20;
color circleColor = color(0);
int circleAlpha = 180;
int actRandomSeed = 0;

void setup(){
  size(960, 540, P3D);
}

void draw() {
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  translate(width/tileCount/2, height/tileCount/2);

  background(0);
  smooth();
  noFill();
  
  randomSeed(actRandomSeed);

  stroke(random(0,255),random(0,255),random(0,255));
  strokeWeight(mouseY/60);

  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {

      float posX = width/tileCount * gridX;
      float posY = height/tileCount * gridY;

      float shiftX = random(-mouseX, mouseX)/20;
      float shiftY = random(-mouseX, mouseX)/20;

      ellipse(posX+shiftX, posY+shiftY, mouseY/2, mouseY/2);
      
      if (key == 'a')
     
      rect(posX+shiftX, posY+shiftY, mouseY/2, mouseY/2);
      
     
      
    }
  }
  
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

void keyPressed() {
  
  if (key == 'w')
  actRandomSeed = (int) random(100000);
  
}

void keyReleased(){
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'p' || key == 'P') savePDF = true;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}