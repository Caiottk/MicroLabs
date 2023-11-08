// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"

///////// DEFINES AND MACROS //////////

typedef enum en_semStates
{
	PIXCA_SEM,
	YELLOW_SEM,
	GREEN_SEM,
	RED_SEM,
} en_semStates;

typedef enum bool
{
	false,
	true
} bool;

///////// EXTERNAL FUNCTIONS INCLUSIONS //////////
// Since there is no .h in most files, theis functions must be included by hand.
// Same as if we were using IMPORT from assembly

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);

void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);
void PortF_Output(uint32_t valor);

void timerInit(void);

void uart_uartInit(void);
unsigned char uart_uartRx(void);
void uart_uartTx(unsigned char txMsg);

///////// LOCAL FUNCTIONS DECLARATIONS //////////

static void Pisca_leds(void);

///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

int main(void)
{
	unsigned char msg = 0;

	PLL_Init();
	SysTick_Init();
	uart_uartInit();
	GPIO_Init();
	timerInit();

	while (1)
	{
		msg = uart_uartRx();
		uart_uartTx(msg);
	}
}

static void Pisca_leds(void)
{
	PortN_Output(0x2);
	SysTick_Wait1ms(250);
	PortN_Output(0x1);
	SysTick_Wait1ms(250);
}

///////// HANDLERS IMPLEMENTATIONS //////////

void GPIOPortJ_Handler(void)
{
	GPIO_PORTJ_AHB_ICR_R = 0x3;

	return;
}

void Timer2A_Handler(void)
{
	TIMER2_ICR_R = 1; // ACKS the interruption
   TIMER2_CTL_R = 1; // Enables timer

   GPIO_PORTN_DATA_R = GPIO_PORTN_DATA_R ^ 1;

	return;
}