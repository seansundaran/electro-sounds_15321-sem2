ArrayList<Integer> list;
float angle;
float jitter;

void setup(){
  size(960,540);
  noStroke();
  fill(255);
  rectMode(CENTER);
  list = new ArrayList();
  
  for(int i=0;i<1000;i++){
    list.add( int( random(0,1000)));
  }
  println(list);
}

void draw(){
  background(0,0,0);
  strokeWeight(5);
 for (int i = 10; i < width; i++) {
    float r = random(200);
   stroke(r);
  line(i, 0, i, height); 
  frameCount=(20);
  strokeWeight(2);
 }
    
    for (int i=0;i<list.size();i++){
      pushMatrix();
      translate(list.get(i),i);
      rotate( ((frameCount+(keyPressed ? i:223))*(mousePressed ? 0.02:0.2)));
      fill(191, i, 0);
      rect(0,0,20,20);
      popMatrix();
      
      pushMatrix();
    translate(width/2,height/2);
    rotate(frameCount*0.01);
    ellipse(0,0,100,100);
    fill(150, 255, 5);
  
    pushMatrix();
    translate(200,0);
    rotate(frameCount*0.1);
    ellipse(0,0,40,40); 
    fill(150, 255, 5);
      pushMatrix();
        translate(40,0);
        rotate(frameCount*0.1);
        ellipse(0,0,10,10); 
        fill(i, 6, 0);
      popMatrix();
    popMatrix();
  
  popMatrix();
  
  if (second() % 2 == 0) {  
    jitter = random(-0.1, 0.1);
  }
  angle = angle + jitter;
  float c = cos(angle);
  translate(width/2, height/2);
  rotate(c);
  rect(0, 0, 180, 180);   
}
}