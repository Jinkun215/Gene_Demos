/*

	Interrupt Demonstration Lab using SysTick_Handler()
	
	Electronics used: TM4C123 Development Board, Switch, 10k Resister, 1k Resister, and an Audiojack
	
	Author: Gene Drumheller
	
	Instructor: Daniel Valvano, Jonathan Valvano
	Date: May 18, 2022

*/


#include "TExaS.h"
#include "..//tm4c123gh6pm.h"




// basic functions defined at end of startup.s
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void WaitForInterrupt(void);  // low power mode

void Sound_Init(void);

//Global Variables
unsigned long forkOn;	
unsigned long switchState;
unsigned long input;




int main(void){// activate grader and set system clock to 80 MHz
  TExaS_Init(SW_PIN_PA3, HEADPHONE_PIN_PA2,ScopeOn); 
  Sound_Init();         
  EnableInterrupts();   // enable after all initialization are done
	
	forkOn = 0;
	switchState = 0;
	
  while(1){
		// Does not use WaitForInterrupt() in this main
		// This means DO NOT PUT ANY CODE IN WHILE(1) - All the code is in SysTick_handler, enabled by EnableInterrupts();
	}
}

// input from PA3, output from PA2, SysTick interrupts
void Sound_Init(void){ 
	unsigned long volatile delay;
	SYSCTL_RCGC2_R |= 0x01;		//activate port A
	delay = SYSCTL_RCGC2_R; 	
		
	GPIO_PORTA_DIR_R |= 0x04;		//set PA3 input, PA2 output
	GPIO_PORTA_DR8R_R |= 0x04;	//Deliver 8mA to PA2
	GPIO_PORTA_AFSEL_R &= 0x00;	//disable Alternative Function
	GPIO_PORTA_PUR_R &= 0x00;	//I guess I don't need this, but disable Pull-Up Resister
	GPIO_PORTA_DEN_R |= 0x0C;		//Enable PA3, PA2
	GPIO_PORTA_AMSEL_R &= 0x00;	//Disable Analog Mode
	GPIO_PORTA_PCTL_R &= 0x00;	//Disable Port Controller (regular function)
	GPIO_PORTA_DATA_R &= 0x00;	//Set every data point to '0';
	
	
	
	NVIC_ST_CTRL_R = 0x00;			//Disable SysTick during configuration
	NVIC_ST_CURRENT_R = 0x00;		//Clear any value
	NVIC_ST_RELOAD_R	= 90908;	//Reload value for one period at 880Hz
	NVIC_SYS_PRI3_R = NVIC_SYS_PRI3_R & 0x00FFFFFF;		//Set the SysTick priority to 0 (highest)
	NVIC_ST_CTRL_R = 0x07;			//Enable SySTick with interrupts
	
}

// The SysTick_Handler is called everytime counter reaches to 0
// The SysTick counter (more specifically the flag register) itself is the interrupt
// The switch users press on PA3 is NOT the interrupt
void SysTick_Handler(void){
	
			//Total of 4 states
			//switchState = 0 && input = 1 -> toggle sound on/off
			//switchState = 1 && input = 0 -> keep sound toggle on/off
			//switchState = 2 && input = 1 -> turn sound off
			//switchState = 3 && input = 0 -> keep sound off
	
		input = GPIO_PORTA_DATA_R & 0x08;
		
		if (input && !switchState) {
			switchState = 1;
			forkOn = 1;
		} else if (!input && switchState == 1) {
			switchState = 2;
			forkOn = 1;
		} else if (input && switchState == 2) {
			switchState = 3;
			forkOn = 0;
		} else if (!input && switchState == 3) {
			switchState = 0;
			forkOn = 0;
		}
	
		if (forkOn)
			GPIO_PORTA_DATA_R ^= 0x04;		// toggle PA2
		else
			GPIO_PORTA_DATA_R &= (~0x04);	//	turn off PA2
		
	
}

