 import codeanticode.syphon.*;
 
SyphonServer server;

 float r = 0;
 
 void settings() {
  size(960,540, P3D);
  PJOGL.profile=1;
}
 
void setup() {
  rectMode(CENTER);
  size(960, 540);
  strokeWeight(60);
  frameRate(60);
  background(0);
  {
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}
}
void draw() { 
  pushMatrix();
  ellipseMode(CENTER); 
  stroke(random(0, 10), random(0, 10));
  fill(random(10, 100), random(200, 255), random(200, 255));
  rotate(r);
  float circle_size = random(5, 10);
  ellipse( 10+r, 100, circle_size, circle_size);
  fill(random(50, 255), 100, random(10, 255));
  ellipse( 50+r, 200, circle_size, circle_size);
  fill(random(50, 255), 100, random(10, 255));
  ellipse( 100+r, 300, circle_size, circle_size);
  fill(random(50, 255), 100, random(10, 255));
  ellipse( 150 +r, 400, circle_size, circle_size);
  fill(random(200, 255), 100, 255);
  ellipse( 200 +r, 500, circle_size, circle_size);
  fill(random(200, 255), random(10, 255), 255);
  ellipse( 250 +r, 600, circle_size, circle_size);
  fill(random(200, 255), random(10, 255), 255);
  ellipse( 300 +r, 700, circle_size, circle_size);
  fill(random(200, 255), random(10, 150), 255);
  ellipse( 350 +r, 800, circle_size, circle_size);
  fill(random(50, 255), random(50, 255), 255);
  ellipse( 400 +r, 900, circle_size, circle_size);
  fill(random(200, 255), random(500, 255), 255);
  ellipse( 450 +r, 1000, circle_size, circle_size);
  fill(random(50, 255), random(50, 255), 255);
  r = r + 0.1;
  popMatrix();
 
{
server.sendScreen();
}
}