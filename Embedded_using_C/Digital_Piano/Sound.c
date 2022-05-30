// Sound.c
// Runs on LM4F120 or TM4C123, 
// Use the SysTick timer to request interrupts at a particular period.

// Author: Gene Drumheller
// Instructer: Daniel Valvano, Jonathan Valvano
// Date: May 30, 2022

// This routine calls the 4-bit DAC

#include "Sound.h"
#include "DAC.h"
#include "..//tm4c123gh6pm.h"


const unsigned long SineWave[32] = { 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 15, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2};		//Index 0 to 31
unsigned long Index = 0;

	
// **************Sound_Init*********************
// Initialize Systick periodic interrupts
// Also calls DAC_Init() to initialize DAC
// Input: none
// Output: none
void Sound_Init(void){
		
		DAC_Init();		//Initialize DAC

		NVIC_ST_CTRL_R = 0x00;	//Disable SysTick during configuration
		NVIC_ST_RELOAD_R	=	0x00FFFFFFFF;	//Just set it to any value, doesn't matter right now
		NVIC_ST_CURRENT_R	= 0x00;	//Get rid of any value currently in SysTick
		NVIC_SYS_PRI3_R = NVIC_SYS_PRI3_R & 0x00FFFFFF;		//Set SysTick to higest priority
		NVIC_ST_CTRL_R = 0x07;		//Enable SysTick
}

// **************Sound_Tone*********************
// Change Systick periodic interrupts to start sound output
// Input: interrupt period
//           Based on Clock Frequency of 80Mhz
// Output: none
void Sound_Tone(unsigned long period){
// this routine sets the RELOAD and starts SysTick
	
		//NVIC_ST_CTRL_R = 0x00;				//Disable SysTick during configuration
		NVIC_ST_RELOAD_R = (period-1) & 0x00FFFFFFFF;			//set the new period
}


// **************Sound_Off*********************
// stop outputing to DAC
// Output: none
void Sound_Off(void){
 // this routine stops the sound output
	NVIC_ST_RELOAD_R = 0;
	DAC_Out(0);
}


// Interrupt service routine
// Executed every 12.5ns*(period)
void SysTick_Handler(void){
	
		
    DAC_Out(SineWave[Index]);			//Sends out value of SineWave array between 1 to 32 based on the Index
		Index = (Index+1)&0x1F;
		
		
	}



