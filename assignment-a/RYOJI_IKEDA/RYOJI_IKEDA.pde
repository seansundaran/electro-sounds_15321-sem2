import codeanticode.syphon.*;
 
SyphonServer server;
 
 
 void settings() {
  size(960,540, P3D);
  PJOGL.profile=1;
}
void setup() {
  size(960, 540, P3D);
  background(0);
  strokeWeight(60);
  
  {
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}
}


void draw()
{
  for (int i = 10; i < width; i++) {
    float r = random(100);
    stroke(r);
    line(i, 0, i, 270);
  }
 
  for (int i = 10; i < width; i++) {
    float r = random(100);
    stroke(r);
    line(i, 271, i, height);
    
}

server.sendScreen();
}