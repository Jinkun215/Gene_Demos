
// Runs on LM4F120 or TM4C123
// Use SysTick interrupts to implement a 4-key digital piano


// Author: Gene Drumheller
// Instructer: Daniel Valvano, Jonathan Valvano
// Date: May 30, 2022
// Port B bits 3-0 have the 4-bit DAC
// Port E bits 3-0 have 4 piano keys

#include "..//tm4c123gh6pm.h"
#include "Sound.h"
#include "Piano.h"
#include "TExaS.h"

unsigned long pianoKey;
unsigned long prevKey;

// basic functions defined at end of startup.s
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void delay(unsigned long msec);


int main(void){ 
	// Real Lab13
	// Must connect PD3 to your DAC output for Real Board
  TExaS_Init(SW_PIN_PE3210, DAC_PIN_PB3210,ScopeOn); // activate grader and set system clock to 80 MHz
	
// PortE used for piano keys, PortB used for DAC    
  Sound_Init(); // initialize SysTick timer and DAC
  Piano_Init();
  EnableInterrupts();  // enable after all initialization are done
	
	pianoKey = 0;
	prevKey = 0;
	
	
  while(1){                
			pianoKey = Piano_In();
		
			while (pianoKey != prevKey) {		//Desired Value = (1/(sample size * sound frequency)) * Clock Frequency
				if (pianoKey == 1)
					Sound_Tone(9541);				// C:    262Hz -> 9541
				else if (pianoKey == 2)
					Sound_Tone(8503);			// D: 		294Hz -> 8503
				else if (pianoKey == 3)
					Sound_Tone(7575);				// E: 		330Hz -> 7575
				else if (pianoKey == 4)
					Sound_Tone(7163);				// F: 		349Hz -> 7163
				else if (pianoKey == 5)
					Sound_Tone(6377);						//G: 		392Hz -> 6377
				else if (pianoKey == 6)
					Sound_Tone(5681);						//A:		440Hz -> 	5681
				else if (pianoKey == 7)
					Sound_Tone(5060);						//B:		494Hz -> 5060
				else if(pianoKey == 8)
					Sound_Tone(4780);						//C:		523Hz -> 4780
				else
					Sound_Off();			//Off for no press or invalid inputs
				
				prevKey = pianoKey;
		}
	}
            
}
