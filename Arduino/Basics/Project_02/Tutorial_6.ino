//Gene Drumheller
//Ardunio Project Handbook Tutorial #6

int sensorValue;
int sensorLow = 1023;
int sensorHigh = 0;

const int ledPin = 13; //connect to on board LED which is at pin 13

void setup() {

  
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);

  //during the 5 seconds from start, set the sensorHigh and sensorLow range
  while (millis() < 5000) {  
    sensorValue = analogRead(A0);
      if (sensorValue > sensorHigh) {
        sensorHigh = sensorValue;
      }
      if (sensorValue < sensorLow) {
        sensorLow = sensorValue;
      }
   }

   digitalWrite(ledPin, LOW); //turn off LED pin 13 after 5 seconds
}

void loop() {

  //read from photoresistor, map to frequency.  tone will play from pin 8 at 'frequency' for 20 milliseconds
  sensorValue = analogRead(A0);
  int frequency = map(sensorValue, sensorLow, sensorHigh, 50, 4000);
  tone(8, frequency, 20);
  delay(10);
}
