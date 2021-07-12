//Gene Drumheller
//Aruino Projects Handbook #9

const int switchPin = 2;
const int motorPin = 9;
int switchState = 0;

void setup() {
  pinMode(motorPin, OUTPUT);
  pinMode(switchPin, INPUT);

}

void loop() {

  //read the state of the switch (button)
  //if button is pressed, connect the motor circuit
  //is button is not pressed, disconnect the motor circuit
  switchState = digitalRead(switchPin);

  if (switchState == HIGH){
    digitalWrite(motorPin, HIGH);
  }
  else {
    digitalWrite(motorPin, LOW);
  }

}
