// Piano.c
// Runs on LM4F120 or TM4C123, 
// edX lab 13 
// There are four keys in the piano

// Author: Gene Drumheller
// Instructer: Daniel Valvano, Jonathan Valvano
// Date: May 30, 2022

// Port E bits 3-0 have 4 piano keys

#include "Piano.h"
#include "..//tm4c123gh6pm.h"


// **************Piano_Init*********************
// Initialize piano key inputs
// Input: none
// Output: none
void Piano_Init(void){ 
		unsigned long volatile delay;
		SYSCTL_RCGC2_R |= 0x10;		//Activate Port E
		delay = SYSCTL_RCGC2_R;
	
		GPIO_PORTE_AFSEL_R &= (~0x0F);	//Disable Port E Alternate Function
		GPIO_PORTE_AMSEL_R &= (~0x0F);	//Disable Port E Analog Mode
		GPIO_PORTE_PCTL_R &= (~0x0000FFFF);		//Disable Port E Port Controller
	
		GPIO_PORTE_DIR_R	&= 0x00;	//Set PB0-3 as Inputs	(
		GPIO_PORTE_DEN_R	|= 0x0F;		//Enable PB0-3
	
		GPIO_PORTE_DATA_R = 0x00;		//Clear any inputs
  
}
// **************Piano_In*********************
// Input from piano key inputs
// Input: none 
// Output: 0 to 15 depending on keys

unsigned long Piano_In(void){
  
		unsigned long input;
		input = GPIO_PORTE_DATA_R & 0x0F;
	
		if (input == 0x01)
			return 1;			
		else if (input == 0x03)
			return 2;
		else if (input == 0x02)
			return 3;
		else if (input == 0x06)
			return 4;
		else if (input == 0x04)
			return 5;
		else if (input == 0x0C)
			return 6;
		else if (input == 0x08)
			return 7;
		else if (input == 0x09)
			return 8;
		else
			return 0;		//if no piano key is pressed or invalid combination pressed, return 0
	
	
}
