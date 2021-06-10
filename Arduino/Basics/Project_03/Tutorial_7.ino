// Gene Drumheller
// Arduino Project Handbook #7

//C = 262Hz
//D = 294Hz
//E = 330Hz
//F = 349Hz

int notes[] = {262, 294, 330, 349};

void setup() {
  Serial.begin(9600);

}

void loop() {

  //KeyVal value based on resistance
  //base resistance (no buttons pressed) = 10k ohms
  //C -> total of 10k ohms
  //D -> total of 10220 ohms
  //E -> total of 20k ohms
  //F -> total of 510k ohms
  
  int keyVal = analogRead(A0);
  Serial.println(keyVal);
  if (keyVal == 1023) {
    tone(8, notes[0]);
  }
  else if (keyVal >= 990 && keyVal <= 1010) {
    tone(8, notes[1]);
  }
  else if (keyVal >= 505 && keyVal <= 525){
    tone(8, notes[2]);
  }
  else if (keyVal >= 5 && keyVal <= 45){
    tone(8, notes[3]);
  }
  else {
    noTone(8);
  }

}
