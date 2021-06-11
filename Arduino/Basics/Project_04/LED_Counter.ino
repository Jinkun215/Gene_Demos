// Gene Drumheller
// Arduino Project Handbook #8

const int switchPin = 8;  //Connected to a tilt switch
unsigned int previousTime = 0;
int switchState = 0;
int prevSwitchState = 0;
int startCount = 1; //added to prevent overlap that automatically restarts the LED counting

int led = 2;  //Starting PIN
long interval = 2000; //Time in milliseconds


void setup() {
  
  for (int x = 2; x < 8; x++) {
    pinMode(x, OUTPUT);
  } //set each pin from 2 to 7 an output

  pinMode(switchPin, INPUT);

}

void loop() {

  unsigned long currentTime = millis();

  //Turn on the current LED to HIGH if currentTime - previousTime is greater than 2 seconds, then jump to next LED
  if (startCount == 1 && currentTime - previousTime > interval) {  
    previousTime = currentTime;
    digitalWrite(led, HIGH);
    led++;
    if (led > 7) {
      startCount = 0;
    }
  } //end if (currentTime - previous Time > interval)

  //If the tilt switch is tilted, reset all LED to OFF and start counting from the first LED pin
  switchState = digitalRead(switchPin);
  if (switchState != prevSwitchState) {
    for (int x = 2; x < 8; x++) {
      digitalWrite(x, LOW);
    }
    led = 2;
    previousTime = currentTime;
    startCount = 1;
  } //end if (switchState != prevSwitchState)

  prevSwitchState = switchState;
  
}
