// DAC.c
// Runs on LM4F120 or TM4C123, 

// Implementation of the 4-bit digital to analog converter

// Author: Gene Drumheller
// Instructer: Daniel Valvano, Jonathan Valvano
// Date: May 30, 2022

// Port B bits 3-0 have the 4-bit DAC

#include "DAC.h"
#include "..//tm4c123gh6pm.h"




// **************DAC_Init*********************
// Initialize 4-bit DAC 
// Input: none
// Output: none
void DAC_Init(void){
		unsigned long volatile delay;
		SYSCTL_RCGC2_R |= 0x02;		//Activate Port B
		delay = SYSCTL_RCGC2_R;
	
		GPIO_PORTB_AFSEL_R &= (~0x0F);	//Disable Port B Alternate Function
		GPIO_PORTB_AMSEL_R &= (~0x0F);	//Disable Port B Analog Mode
		GPIO_PORTB_PCTL_R &= (~0x0000FFFF);		//Disable Port B Port Controller
	
		GPIO_PORTB_DR8R_R |= 0x0F;		//Enable 8mA current on PB0-3
	
		GPIO_PORTB_DIR_R	|= 0x0F;	//Set PB0-3 as Outputs	(
		GPIO_PORTB_DEN_R	|= 0x0F;		//Enable PB0-3
}


// **************DAC_Out*********************
// output to DAC
// Input: 4-bit data, 0 to 15 
// Output: none
void DAC_Out(unsigned long data){
  
		GPIO_PORTB_DATA_R = data;
	
}
