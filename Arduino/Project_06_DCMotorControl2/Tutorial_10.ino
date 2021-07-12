//Gene Drumheller
//Arduino Project Handbook #10 Zoetrope

//assign pin names and the where it's pinned to Arduino
const int controlPin1 = 2;
const int controlPin2 = 3;
const int enablePin = 9;
const int directionPin = 4;
const int onOffStatePin = 5;
const int potentioPin = A0;

//assign state starting value
int onOffState = 0;
int previousOnOffState = 0;
int directionState = 0;
int previousDirectionState = 0;

//assign motor starting value
int motorEnabled = 0;
int motorSpeed = 0;
int motorDirection = 1;

void setup() {
  pinMode(directionPin, INPUT);
  pinMode(onOffStatePin, INPUT);
  pinMode(controlPin1, OUTPUT);
  pinMode(controlPin2, OUTPUT);
  pinMode(enablePin, OUTPUT);
  
  digitalWrite(enablePin, LOW);
}

void loop() {
  //Read state HIGH or LOW on the two buttons, and read motorspeed value /4
  onOffState = digitalRead(onOffStatePin);
  delay(1);
  directionState = digitalRead(directionPin);
  motorSpeed = analogRead(potentioPin)/4;

  //Change Enable
  if(onOffState != previousOnOffState) {
    if (onOffState == HIGH) {
      motorEnabled = !motorEnabled;
    }
  }

  //Change direction
  if (directionState != previousDirectionState) {
    if (directionState == HIGH) {
      motorDirection = !motorDirection;
    }
  }

  //Change direction of current using H-Bridge
  if (motorDirection == 1) {
    digitalWrite(controlPin1, HIGH);
    digitalWrite(controlPin2, LOW);
  }
  else {
    digitalWrite(controlPin1, LOW);
    digitalWrite(controlPin2, HIGH);    
  }

  //Change speed
  if (motorEnabled == 1) {
    analogWrite(enablePin, motorSpeed);
  }
  else {
    analogWrite(enablePin, 0);
  }

  previousDirectionState = directionState;
  previousOnOffState = onOffState;
  
}
