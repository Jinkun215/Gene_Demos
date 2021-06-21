//Gene Drumheller
//Arduino Project Handbook #14

import processing.serial.*;
Serial myPort;  //make Serial communication object

PImage logo;  //make PIamge object
int bgcolor = 0;

void setup() {
  colorMode(HSB, 255); //HSB = Hue, Saturation, and Brightness from value 0 to 255
  logo = loadImage("https://www.arduino.cc/en/pub/skins/arduinoWide/img/logo.png");
  size(170, 120);  //size() function tell Processing how large the display window will be
  
  println("Available serial ports: ");
  println(Serial.list());  //lists all the serial ports your computer has when the program first start
  
  myPort = new Serial(this, "COM8", 9600);  //which application it will be speaking to (this), which serial port it will communicate over (Serial.list()[0], and at what speed
} //end void setup()

 void draw() {
    
    if (myPort.available() > 0) { //available() command tells you if there is something in the serial buffer
      bgcolor = myPort.read();
      println(bgcolor);
    }
    background(bgcolor, 255, 255);
    image(logo, 0, 0);
} 
