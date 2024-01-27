// Author: Gene Drumheller

// Instructor: Daniel Valvano
// Date: June 2nd, 2022

// Slide pot pin 3 connected to +3.3V
// Slide pot pin 2 connected to PE2(Ain1) and PD3(Voltmeter)
// Slide pot pin 1 connected to ground


#include "ADC.h"
#include "..//tm4c123gh6pm.h"
#include "TExaS.h"

void EnableInterrupts(void);  // Enable interrupts

unsigned char String[10]; // null-terminated ASCII string
unsigned long Distance;   // units 0.001 cm
unsigned long ADCdata;    // 12-bit 0 to 4095 sample
unsigned long Flag;       // 1 means valid Distance, 0 means Distance is empty


//Function Prototypes
void UART_Init();
void UART_OutChar(unsigned char);
void UART_OutString(unsigned char[]);
void UART_ConvertDistance(unsigned long);
unsigned long Convert(unsigned long);
void SysTick_Init(unsigned long);
void SysTick_Handler(void);
void PortF_Init(void);





//initialize UART0
void UART_Init(void){

  SYSCTL_RCGC1_R |= SYSCTL_RCGC1_UART0; // activate UART0
  SYSCTL_RCGC2_R |= SYSCTL_RCGC2_GPIOA; // activate port A
  UART0_CTL_R &= ~UART_CTL_UARTEN;      // disable UART
  UART0_IBRD_R = 43;                    // IBRD = int(80,000,000 / (16 * 115200)) = int(43.402778)
  UART0_FBRD_R = 26;                    // FBRD = round(0.402778 * 64) = 26
                                        // 8 bit word length (no parity bits, one stop bit, FIFOs)
  UART0_LCRH_R = (UART_LCRH_WLEN_8|UART_LCRH_FEN);
  UART0_CTL_R |= UART_CTL_UARTEN;       // enable UART
  GPIO_PORTA_AFSEL_R |= 0x03;           // enable alt funct on PA1,PA0
  GPIO_PORTA_DEN_R |= 0x03;             // enable digital I/O on PA1,PA0
                                        // configure PA1,PA0 as UART0
  GPIO_PORTA_PCTL_R = (GPIO_PORTA_PCTL_R&0xFFFFFF00)+0x00000011;
  GPIO_PORTA_AMSEL_R &= ~0x03;          // disable analog functionality on PA1,PA0
}

void UART_OutChar(unsigned char data){
	
  while((UART0_FR_R&UART_FR_TXFF) != 0);
  UART0_DR_R = data;
}

void UART_OutString(unsigned char buffer[]){
	
	unsigned int i = 0;
	while (buffer[i]) {
		UART_OutChar(buffer[i]);
		i++;
	}

}
void UART_ConvertDistance(unsigned long n){

		unsigned int i;	
	for (i = 0; i < 10; i++)	//clear unused space
		String[i] = 0;
	
	
		if (n > 9999) {
		String[0] = '*';
		String[1] = '.';
		String[2] = '*';
		String[3] = '*';
		String[4] = '*';
		String[5] = ' ';
		String[6] = 'c';
		String[7] = 'm';
		String[8] = '\0';
	}
	else if (n > 999) {
		String[0] = n / 100 / 10 + '0';
		String[1] = '.';
		String[2] = n / 100 % 10 + '0';
		String[3] = n / 10 % 10 + '0';
		String[4] = n % 10 + '0';
		String[5] = ' ';
		String[6] = 'c';
		String[7] = 'm';
		String[8] = '\0';
	}
	else if (n > 99) {
		String[0] = '0';
		String[1] = '.';
		String[2] = n / 10 / 10 + '0';
		String[3] = n / 10 % 10 + '0';
		String[4] = n % 10 + '0';
		String[5] = ' ';
		String[6] = 'c';
		String[7] = 'm';
		String[8] = '\0';
	}
	else if (n > 9) {
		String[0] = '0';
		String[1] = '.';
		String[2] = '0';
		String[3] = n / 10 + '0';
		String[4] = n % 10 + '0';
		String[5] = ' ';
		String[6] = 'c';
		String[7] = 'm';
		String[8] = '\0';
	}
	else {
		String[0] = '0';
		String[1] = '.';
		String[2] = '0';
		String[3] = '0';
		String[4] = n + '0';
		String[5] = ' ';
		String[6] = 'c';
		String[7] = 'm';
		String[8] = '\0';
	}

 
}



//********Convert****************
// Convert a 12-bit binary ADC sample into a 32-bit unsigned
// fixed-point distance (resolution 0.001 cm).  Calibration
// data is gathered using known distances and reading the
// ADC value measured on PE1.  
// Overflow and dropout should be considered 
// Input: sample  12-bit ADC sample
// Output: 32-bit distance (resolution 0.001cm)
unsigned long Convert(unsigned long sample){
	unsigned long result;
  result = sample * 1000 / 2047;			//ulong 1 = 0.001cm, ulong 1000 = 1cm, ulong 2000 = 2cm
	return result;
}

// Initialize SysTick interrupts to trigger at 40 Hz, 25 ms
void SysTick_Init(unsigned long period){
  NVIC_ST_CTRL_R = 0x00;
	NVIC_ST_RELOAD_R = period-1;
	NVIC_ST_CURRENT_R = 0;
	NVIC_ST_CTRL_R = 0x07;
}
// executes every 25 ms, collects a sample, converts and stores in mailbox
void SysTick_Handler(void){ 
		GPIO_PORTF_DATA_R ^= 0x01;		//Toggle PF1
		GPIO_PORTF_DATA_R ^= 0x01;			//Toggle PF1 again
		ADCdata = ADC0_In();					
		Distance = Convert(ADCdata);		
		Flag = 1;		//Set Flag on, signifying new data is ready
		GPIO_PORTF_DATA_R ^= 0x01;		//Toggle PF1
}

void PortF_Init(void) {
	unsigned long volatile delay;
	SYSCTL_RCGC2_R |= 0x20;				// Step 1. Activate Clock for Port F
	delay = SYSCTL_RCGC2_R;
	GPIO_PORTF_DIR_R |= 0x01;		// Step 2. Make PF1 Output
	GPIO_PORTF_AFSEL_R &= ~0x01;		// Step 3. Disable Alternate Function on PF1
	GPIO_PORTF_DEN_R |= 0x01;		// Step 4. Enagle Digital Enable on PF1
	GPIO_PORTF_AMSEL_R &= ~0x01;		//Step 5. Disable Analog Mode on PF1
	GPIO_PORTF_DATA_R = 0x00;				//Clear any data on Port F
}




int main(void){ 
	
	TExaS_Init(ADC0_AIN1_PIN_PE2, UART0_Emulate_Nokia5110_NoScope);
	ADC0_Init();    // initialize ADC0, channel 1, sequencer 3
	UART_Init();			//Initialize UART0
	SysTick_Init(2000000);		//Initialize SysTick at 40Hz  
	PortF_Init();		//Initialize Port F
	EnableInterrupts();	
	Flag = 0;		//Reset Flag
	while(1) {
		
		while (Flag != 1) {			//Wait until Flag toggles
		}
		UART_ConvertDistance(Distance);		//Display on UART0
		UART_OutString(String);
		UART_OutChar('\n');

		
	}
	
}

