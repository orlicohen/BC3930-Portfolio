import processing.serial.*;
import processing.sound.*;

Serial myPort;  // Create object from Serial class

String val;      
int x; //joystick x-coordinate
int y; //joystick y-coordinate
int z = 1; //joystick button
int adc;
int p;

boolean top; 
boolean bottom;

PImage dog;
PImage squirrel;
PImage bark;
PImage park;

Squirrel[] squirrel_arr;

int dog_x; 
int dog_y; 

int score = 0;

SoundFile bark_sound;

void setup() {
  
  size(700, 700);
  String portName = Serial.list()[1];
  System.out.println(portName);
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil(10);
    
  dog = loadImage("/Users/orlicohen/Downloads/d.png");
  squirrel = loadImage("/Users/orlicohen/Downloads/squirrel.png");
  bark = loadImage("/Users/orlicohen/Downloads/bark.png");
  park = loadImage("/Users/orlicohen/Downloads/park.png");
  
  bark_sound = new SoundFile(this, "/Users/orlicohen/Downloads/bark_sound.wav");
  bark_sound.amp(.5); 
  
  squirrel_arr = new Squirrel[1];

  top = false;
  bottom = false;
}

void draw() {  
  //Set background to park 
  background(park);  

  // set text displays with score and instructions
  String str = "Score: " + score;
  fill(255);
  text(str, 35, 35);
  text("Move the dog until you get into range, then press the joystick to bark!", 35, 50);
  
  //Create dog object that moves via joystick
  dog_x = int(x/7.25); //int((x+1) * 0.14041514041); //x/9;
  dog_y = int(y/7.25);//int((y+1) * 0.14041514041); //700-(y/2); //(y/10) - 30;
  image(dog, dog_x, dog_y, 150, 125);
  image(bark, dog_x-10, dog_y, 75, 75);

  // create/reinit squirrel 
  newSquirrel();
  int sq_x = squirrel_arr[0].x; //int(squirrel_arr[0].x * 5.85); // messing with mapping analog values to coordinates
  int sq_y = squirrel_arr[0].y; //int(squirrel_arr[0].y * 5.85); 
  
  // print statements to observe x/y coords and button value of squirrel and dog 
  print("\nDOG X, DOG Y: ", dog_x, dog_y);
  print("\nSQ X, SQ Y: ", sq_x, sq_y);
  print("\n Z:", z);

  overlap(dog_x, dog_y, sq_x, sq_y); // check for in range 
  if(top && bottom){
    // display to user they are within range 
    fill(0);
    rect(20, 50, 120, 30);
    fill(255);
    text("YOU'RE IN RANGE!", 35, 70);
    fill(255,255,255,50);  
    rect(dog_x - 5, dog_y - 5, 155, 130);
    
    if(z==0){ // clicked
      // make bark sound, move squirrel, reset dog/bark animation, increase score, reset overlap
      bark_sound.play();
      
      squirrel_arr[0] = null;
      newSquirrel();
      image(dog, dog_x, dog_y, 150, 125);
      image(bark, dog_x-10, dog_y, 75, 75);
      
      top = false;
      bottom = false;
      
      score++;
    }
  }
  
  String vals[] = split(val, ',');
 
  //print("val:", val);
  x = int(vals[1]);
  //x = int(map(x, 0, 4095, 0, 550));
  //print("\nx:", x);
  y = int(vals[2]);
  //y = int(map(y, 0, 4095, 0, 550));
  //print("\ny:", y);
  z = int(vals[3]);
  //print("\nz:", z);

  delay(100);
  
  // if using potentiometer to adjust volume of bark: 
  //float volume = map(adc, 4092, 0, 1, 0); // control volume with potentiometer 
  
  float volume = .5; // make this controllable by potentiometer 
  bark_sound.amp(volume);

}

void serialEvent (Serial myPort){
  
  try {
    val = myPort.readString();
  } 
  
  catch(RuntimeException e) {
    e.printStackTrace();
  }
  
}

void newSquirrel(){
    if(squirrel_arr[0] == null){ // ensure only one squirrel at a time 
      int squirrel_x = int(random(0, width-100));
      int squirrel_y = int(random(0, height-100));
      
      Squirrel sq = new Squirrel(squirrel_x, squirrel_y);
      
      squirrel_arr[0] = sq;
    }
    else{
      image(squirrel, squirrel_arr[0].x, squirrel_arr[0].y, 75, 75);
    }
}

void overlap(int dog_x, int dog_y, int sq_x, int sq_y){
   if((dog_x - 50 >= sq_x && dog_x <= sq_x + 75) || (dog_x + 100 >= sq_x && dog_x + 100 <= sq_x + 75)){
    top = true;
  }
  
  if((dog_y >= sq_y && dog_y <= sq_y + 75) || (dog_y + 125 >= sq_y && dog_y + 125 <= sq_y + 75)){
    bottom =true;
  }
}

class Squirrel{
  PImage squirrel = loadImage("/Users/orlicohen/Downloads/squirrel.png");
  
  int x;
  int y;
  
  Squirrel(int x, int y){
    this.x = x;
    this.y = y;
    image(squirrel, x, y, 75, 75);
  }

}

class Point{
  int x;
  int y;
  
  Point(int x, int y){
    this.x = x;
    this.y = y;
  }
}
  
