//Gene Drumheller
//Arduino Project Handbook #11: Crystal Ball

#include <LiquidCrystal.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);  //using LiquidCrystal, instantiate lcd with assigned pins

//set up variables
const int switchPin = 6;
int switchState = 0;
int prevSwitchState = 0;
int reply = 0;

void setup() {
  lcd.begin(16, 2); //tell how large screen is -> 16 column, 2 row
  pinMode(switchPin, INPUT);

  //display initial output    
  lcd.print("Ask the");
  lcd.setCursor(0,1);
  lcd.print("Crystal Ball!");

}

void loop() {
  switchState = digitalRead(switchPin); //check if pin on enable or not

  //if button is clicked, do the following
  if (switchState != prevSwitchState) {
    if (switchState == LOW) {
      reply = random(8); //reply will be a value 0 to 7

      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("The ball says: ");
      lcd.setCursor(0, 1);

      switch(reply) {
        case 0:
          lcd.print("Yes");
          break;
        case 1:
          lcd.print("Most likely");
          break;
        case 2:
          lcd.print("Certainly");
          break;
        case 3:
          lcd.print("Outlook good");
          break;
        case 4:
          lcd.print("Unsure");
          break;
        case 5:
          lcd.print("Ask again");
          break;
        case 6:
          lcd.print("Doubtful");
          break;
        case 7:
          lcd.print("No");
          break;
          
      }
    }
  }

  //store state value so button can be clicked
  prevSwitchState = switchState;
}
