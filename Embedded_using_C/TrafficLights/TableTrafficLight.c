// ***** 0. Documentation Section *****
// TableTrafficLight.c for Lab 10

// Runs on LM4F120/TM4C123
// Index implementation of a Moore finite state machine to operate a traffic light.  
// Author: Gene Drumheller
// Instructor: Daniel Valvano, Jonathan Valvano
// May 8th, 2022


// ***** 1. Pre-processor Directives Section *****
#include "TExaS.h"
#include "tm4c123gh6pm.h"

#define GoEast 0
#define WaitEastToSouth 1
#define WaitEastToWalk 2
#define GoSouth 3
#define WaitSouthToEast 4
#define WaitSouthToWalk 5
#define GoWalk 6
#define WalkBlinkOff1 7
#define WalkBlinkOn1 8
#define WalkBlinkOff2 9
#define WalkBlinkOn2 10
#define WalkBlinkOff3	11
#define WalkBlinkOn3 12
#define WaitWalkToEast 13
#define WaitWalkToSouth 14

struct state {
	
	unsigned long outputPB;
	unsigned long outputPF;
	unsigned long time;
	unsigned long next[5];
	
};

typedef struct state SType;

// ***** 2. Global Declarations Section *****

//In this Project, I decided not to use variable or conditional branching to set build the blinking of LED
//It must go from state to state, hence there is extra state for the blinks
//Additionally, this is a simple version where I expect the user to only enter 1 switch at a time (no input, 001 010 or 100)
//Hence, the explicit 0 at the next[4] is a place holder
//001 = Go to Walk
//010 = Go to South
//100 = Go to East

SType FSM[14] = {
	
	{ 0x0C, 0x02, 100, { GoEast ,GoEast, WaitEastToSouth, 0, WaitEastToWalk}  },	//Pattern 0 Go East
	{ 0x14, 0x02, 50, { GoSouth ,GoSouth, GoSouth,  0, GoSouth}  },								//Pattern 1 WaitEastToSouth
	{ 0x14, 0x02, 50, { GoWalk ,GoWalk, GoWalk, 0, GoWalk}  },										//Pattern 2 WaitEastToWalk
	{ 0x21, 0x02, 100, {GoSouth, WaitSouthToEast, GoSouth, 0, WaitSouthToWalk} },	//Pattern 3 GoSouth
	{ 0x22, 0x02, 50, {GoEast , GoEast, GoEast, 0, GoEast} },										//Pattern 4 WaitSouthToEast
	{ 0x22, 0x02, 50, {GoEast , GoWalk, GoWalk, 0, GoWalk} },										//Pattern 5 WaitSouthToWalk
	{ 0x24, 0x08, 100, {GoWalk , WalkBlinkOff1, WalkBlinkOff1, 0, GoWalk}  },			//Pattern 6 Go Walk
	{ 0x24, 0x00, 25, { WalkBlinkOn1, WalkBlinkOn1, WalkBlinkOn1, 0, WalkBlinkOn1}  },	//Pattern 7 WalkBlinkOff1
	{ 0x24, 0x02, 25, {WalkBlinkOff2, WalkBlinkOff2, WalkBlinkOff2, 0, WalkBlinkOff2} },//Pattern 8 WalkBlinkOn1
	{ 0x24, 0x00, 25, {WalkBlinkOn2, WalkBlinkOn2, WalkBlinkOn2, 0, WalkBlinkOn2}  },	//Pattern 9 WalkBlinkOff2
	{ 0x24, 0x02, 25, {WalkBlinkOff3, WalkBlinkOff3, WalkBlinkOff3, 0, WalkBlinkOff3}  },//Pattern 10 WalkBlinkOn3
	{ 0x24, 0x00, 25, {WalkBlinkOn3, WalkBlinkOn3, WalkBlinkOn3, 0, WalkBlinkOn3}  },	//Pattern 11 WalkBlinkOff3
	{ 0x24, 0x00, 25, {GoEast, GoEast, GoEast, 0, GoEast}  },										//Pattern 12 WaitWalkToEast
	{ 0x24, 0x00, 25, { GoSouth, GoSouth, GoSouth, 0, GoSouth}  }									//Pattern 13 WaitWalkToSouth
	
};



// ***** 3. Subroutines Section *****

// FUNCTION PROTOTYPES: Each subroutine defined
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts

void Ports_Init(void);
void SysTick_Init(void);
void SysTick_Wait(unsigned long delay);
void SysTick_Wait10ms(unsigned long delay);


int main(void){ 

	unsigned long state_index;
	unsigned long input;
	
  TExaS_Init(SW_PIN_PE210, LED_PIN_PB543210,ScopeOff); // activate grader and set system clock to 80 MHz
	Ports_Init();  //Initialize PortB, PortE, and PortF
	SysTick_Init();	//Initialize SysTick
  EnableInterrupts();
	
	state_index = GoEast;	//Starts program at Pattern 0, GoEast
	
  while(1){
		
		//GPIO_PORTF_DATA_R	outputs PF3 and PF1 for Walk
		//GPIO_PORTE_DATA_R	inputs PE2, PE1, and PE0
		//GPIO_PORTB_DATA_R	outputs PB5-0 for Traffic Lights
		
     GPIO_PORTB_DATA_R = FSM[state_index].outputPB;		//Load the LED output for Port B
		 GPIO_PORTF_DATA_R = FSM[state_index].outputPF;		//Load the LED output for Port F
		
		SysTick_Wait10ms(FSM[state_index].time);		//wait desired time
		
		input = GPIO_PORTE_DATA_R & 0x07;					//read the user input
		
		state_index = FSM[state_index].next[input];	//go to next state
  }
}

void Ports_Init(void) {
	volatile unsigned long delay;
	SYSCTL_RCGC2_R |= 0x32;		//activate clock for Port B, E, and F
	delay = SYSCTL_RCGC2_R;
	
	GPIO_PORTF_LOCK_R = 0x4C4F434B;	//unlock GPIO Port F
	GPIO_PORTF_CR_R = 0x1F;	//allow changes to portF4-0
	GPIO_PORTF_AMSEL_R = 0x00;	//disable analog on PortF
	GPIO_PORTF_PCTL_R = 0x00000000;	//Enable regular GPIO PortF
	GPIO_PORTF_DIR_R = 0x0A;	//set PF3 and PF1 as outputs
	GPIO_PORTF_AFSEL_R = 0x00;	//disable alt function on Port F
	GPIO_PORTF_PUR_R = 0x00;	//disable any pullup registers
	GPIO_PORTF_DEN_R = 0x0A;	//enable PF3 and PF1
	GPIO_PORTF_DATA_R = 0x02;
	
	GPIO_PORTE_AMSEL_R = 0x00;	//disable analog on PortE
	GPIO_PORTE_PCTL_R = 0x00000000; //Enable regular GPIO PortE
	GPIO_PORTE_DIR_R = 0x00;	//set PE2-0 as Inputs
	GPIO_PORTE_AFSEL_R = 0x00;	//disable alt function on Port E
	GPIO_PORTE_PUR_R = 0x00;	//disable any pullup registers
	GPIO_PORTE_DEN_R = 0x07;	//enable PE2-0
	GPIO_PORTE_DATA_R = 0x00;
	
	GPIO_PORTB_AMSEL_R = 0x00; 	//disable analog on PortB
	GPIO_PORTB_PCTL_R = 0x00000000; //enable regular GPIO PortB
	GPIO_PORTB_DIR_R = 0x3F;	//set PB5-0 as outputs
	GPIO_PORTB_AFSEL_R = 0x00;	//disable alt function on Port B
	GPIO_PORTB_PUR_R = 0x00;		//disable any pullup registers
	GPIO_PORTB_DEN_R = 0x3F;	//enable PB5-0
	GPIO_PORTB_DATA_R = 0x0C;
	
	
}

void SysTick_Init(void) {
	
	NVIC_ST_CTRL_R = 0;	//disable SysTick during setup
	NVIC_ST_RELOAD_R = 0x00FFFFFF;	//maximum reload value
	NVIC_ST_CURRENT_R = 0;	//clear any values on SysTick
	NVIC_ST_CTRL_R = 0x00000005;	//Enable SysTick
	
}


void SysTick_Wait(unsigned long delay) {
	NVIC_ST_RELOAD_R = delay-1;
	NVIC_ST_CURRENT_R = 0;
	while ((NVIC_ST_CTRL_R & 0x00010000) == 0) {
				//this loop waits for count flag
				//flagged every clock period
				//using 80MHz clock, flags every 12.5ns
	}
}

void SysTick_Wait10ms(unsigned long delay) {
	
	unsigned long i;
	unsigned cycle;
	cycle = 800000;		//cycle = desired time / clock period = 10ms / 12.5ns
	for (i = 0; i < delay; i++)
		SysTick_Wait(cycle);

}
