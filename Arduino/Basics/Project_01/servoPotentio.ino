//Tutorial #5 
//Move Servo Motor using a Potentiometer
//Gene Drumheller
#include <Servo.h>

Servo myServo;
int const potPin = A0;  //Potentiometer hooked to port A0
int potVal;
int angle;

void setup() {
  // put your setup code here, to run once:

  myServo.attach(9);  //Servo hooked to porn 9
  Serial.begin(9600);

 }

void loop() {
  // put your main code here, to run repeatedly:
  potVal = analogRead(potPin);  //Read data from analog potPin into potVal
  Serial.print("potVal: ");
  Serial.print(potVal);

  angle = map(potVal, 0, 1023, 0, 179); //convert potVal, that is 0 to 1023 into 0 to 179 (in angles)
  Serial.print(", angle: ");
  Serial.println(angle);

  myServo.write(angle); //move the Servo
  delay(15);
}
