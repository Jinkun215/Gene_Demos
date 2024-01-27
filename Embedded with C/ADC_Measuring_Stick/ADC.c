
// Author: Gene Drumheller

// Instructor: Daniel Valvano
// Date: June 2nd, 2022



#include "ADC.h"
#include "..//tm4c123gh6pm.h"

// This initialization function sets up the ADC 
// Max sample rate: <=125,000 samples/second
// SS3 triggering event: software trigger
// SS3 1st sample source:  channel 1
// SS3 interrupts: enabled but not promoted to controller

void ADC0_Init(void){ 
	unsigned long volatile delay;
	SYSCTL_RCGC2_R |= 0x10;				// Step 1. Activate Clock for Port E
	delay = SYSCTL_RCGC2_R;
	GPIO_PORTE_DIR_R &= ~0x04;		// Step 2. Make PE2 (AIN1) input
	GPIO_PORTE_AFSEL_R |= 0x04;		// Step 3. Enable Alternate Function on PE2
	GPIO_PORTE_DEN_R &= ~0x04;		// Step 4. Disable Digital I/O on PE2
	GPIO_PORTE_AMSEL_R |= 0x04;		// Step 5. Enable Analog Function on PE2
	SYSCTL_RCGC0_R |= 0x00010000;	// Step 6. Activate ADC0		-- Note to self: ADC =/= AIN so ADC0 and AIN1 is not directly related
	delay = SYSCTL_RCGC2_R;
	SYSCTL_RCGC0_R &= ~0x00000300;			// Step 7. Configure sampling rate 125k/sec
	ADC0_SSPRI_R = 0x0123;						// Step 8. Set Sequencer 3 as highest priority
	ADC0_ACTSS_R = ~0x08;						 // Step 9. Disable sample sequencer 3
	ADC0_EMUX_R &= ~0xF000;						// Step 10. Set Software Trigger
	ADC0_SSMUX3_R &= ~0x000F;						// Step 11. Clear SS3 field, set Channel AIN1
	ADC0_SSMUX3_R += 1;
	ADC0_SSCTL3_R = 0x0006;							// Step 12. No TS0 and D0, yes IE0 and END0
	ADC0_ACTSS_R = 0x08;							// Step 13. Enable sample sequencer 3
	
}


//------------ADC0_In------------
// Busy-wait Analog to digital conversion
// Input: none
// Output: 12-bit result of ADC conversion
unsigned long ADC0_In(void){  
 
	unsigned long results;
	ADC0_PSSI_R = 0x0008;					//initiate Processor Sample Sequence Initiate sequencer 3
	while ((ADC0_RIS_R & 0x08) == 0) {		//Wait until Raw INterrupt Status == 1
	}
	results = ADC0_SSFIFO3_R & 0xFFF;		// read Sample Sequence Result FIFO3
	ADC0_ISC_R = 0x0008;						//	Reset Interrupt Status and Clear
	return results;	
}
