import processing.serial.*;
import processing.sound.*;
SoundFile hit;
SoundFile move;
SoundFile fill;

Serial myPort;  
String val;    
String lastVal;
String validVal;
int posx = 0;
int posy = 0;
int cellNum;
int blinkTime;
boolean blinkOn;
boolean[] cellFill = new boolean[10*10];

void setup() {
  
  background(255);
  size(800,800);
  strokeWeight(2);
  
  // serial communication with arduino
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600); 

  // set variables for blinking cursor
  blinkTime = millis();
  blinkOn = true;
  
  // sounds
  hit = new SoundFile(this, "hit.wav");
  move = new SoundFile(this, "move.wav");
  fill = new SoundFile(this, "fill.wav");
  
}
 
void draw() {
  
  drawGrid();
  cursorBlink();
  
  // serial communication with arduino
  if ( myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
  } 
  
  if (val != null) {
    if (lastVal != val) {
      val = val.replace("newInput","");
      validVal = trim(val);
      lastVal = val;
      moveFillErase(validVal);
    }
  }
}

void drawGrid() {
  stroke(199, 228, 255);
  int grid = 80;
  for (int i = 0; i < width+grid; i+=grid) {
    line (i, 0, i, height);
  }
  for (int i = 0; i < height+grid; i+=grid) {
    line (0, i, width, i);
  }
}
  
void cursorBlink() {
  if (blinkOn) {
    stroke(255, 0, 0);
    beginShape(LINES);
    vertex(posx, posy);
    vertex(posx+80, posy);
    vertex(posx+80, posy);
    vertex(posx+80, posy+80);
    vertex(posx+80, posy+80);
    vertex(posx, posy+80);
    vertex(posx, posy+80);
    vertex(posx, posy);
    endShape();
  }
  else {
    stroke(199, 228, 255);
    beginShape(LINES);
    vertex(posx, posy);
    vertex(posx+80, posy);
    vertex(posx+80, posy);
    vertex(posx+80, posy+80);
    vertex(posx+80, posy+80);
    vertex(posx, posy+80);
    vertex(posx, posy+80);
    vertex(posx, posy);
    endShape();
  }
  if (millis() - 500 > blinkTime) {
    blinkTime = millis();
    blinkOn = !blinkOn;
  }
}

void moveFillErase(String validVal) {
  println(validVal);
   
  if (validVal.equals("LEFT")) {
    if (posx > 0) {
      move.play();
      posx-=80;
    }
    else {
      hit.play();
      posx-=0;
    }
  }
  if (validVal.equals("RIGHT")) {
    if (posx < 720) {
      move.play();
      posx+=80;
    }
    else {
      hit.play();
      posx+=0;
    }
  }
  if (validVal.equals("UP")) {
    if (posy > 0) {
      move.play();
      posy-=80;
    }
    else {
      hit.play();
      posy-=0;
    }
  }
  if (validVal.equals("DOWN")) {
    if (posy < 720) {
      move.play();
      posy+=80;
    }
    else {
      hit.play();
      posy+=0;
    }
  }
  if (validVal.equals("FAR") || (validVal.equals("NEAR") || validVal.equals("NONE"))) {
    int cellNum = ((posy+80)/80-1) * 10 + ((posx+80)/80-1);
    stroke(255, 80, 100);
    if (cellFill[cellNum] == true) {
      fill.play();
      fill(255);
    }
    else {
      fill.play();
      fill (255, 80, 50);
    }
    rect(posx, posy, 80, 80);
    cellFill[cellNum] = !cellFill[cellNum];
  }
} 

void keyPressed() {
  if (keyCode == CONTROL) {
    background(255);
    }
  if (key == 's') {
    save(hour()+"-"+minute()+"-"+second()+".png");
  } 
}