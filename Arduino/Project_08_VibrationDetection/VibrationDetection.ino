//Gene Drumheller
//Arduino Project Handbook #12: Knock Lock

//Load library and create a class
#include <Servo.h>
Servo myServo;

//set up names for pins
const int piezo = A0;
const int switchPin = 2;
const int greenLed = 4;
const int redLed = 5;
const int servoPin = 9;

//set up variables
int knockVal;
int switchVal;
const int quietKnock = 10;    //value between 10 to 100 due to 1Mohm resistor
const int loudKnock = 100;
boolean locked = false;
int numberOfKnocks = 0;


void setup() {
  //Assign pin mode to each input/output
  myServo.attach(servoPin);
  pinMode(redLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  pinMode(switchPin, INPUT);
  
  Serial.begin(9600);
  digitalWrite(greenLed, HIGH);

  //angle 0 and green HIGH means unlocked
  myServo.write(0);
  Serial.println("The box is unlocked!");

}

void loop() {

  //when green LED is on or servo at 0, if button switch is pressed do the following
 if (locked == false) {
  switchVal = digitalRead(switchPin); //read value detected from button switch
  if (switchVal == HIGH) {
    locked = true;
    digitalWrite(greenLed, LOW);
    digitalWrite(redLed, HIGH);
    myServo.write(90);
    Serial.println("The box is locked!");
    delay(1000);
  }
 } //end if (locked == false)

  //Read the vibration, increase numberOfKnocks.  If Knock >= 3, unlock the servo
  if (locked == true) {
  knockVal = analogRead(piezo); //read value detected from piezo
  if (numberOfKnocks < 3 ) {
    if (checkForKnock(knockVal) == true) {
    numberOfKnocks++;
    }
  } //end if (numberOfKnocks < 3 && knockVal > 0)

  if (numberOfKnocks >= 3) {
    locked = false;
    myServo.write(0);
    delay(20);
    digitalWrite(greenLed, HIGH);
    digitalWrite(redLed, LOW);
    Serial.println("The box is unlocked!");
    numberOfKnocks = 0;
    
  } //end if (numberOfKnocks >= 3)
 } //end if (locked == true)
} //end loop()



boolean checkForKnock(int value) {

  
  if (value > quietKnock && value < loudKnock) {
    Serial.print("Valid knock of value ");
    Serial.println(value);
    return true;
  }
  else {
    Serial.print("Bad knock value ");
    Serial.println(value);
    return false;
  }
}
