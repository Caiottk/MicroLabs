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

uint32_t passo;
uint32_t contPasso;
uint32_t sysState;
uint32_t readState;
uint32_t motorPosition;
uint32_t passo_completo[4] = {0x03, 0x06, 0x0C, 0x09};
uint32_t meio_passo[8] = {0x01, 0x03, 0x02, 0x06, 0x04, 0x0C, 0x08, 0x09};
unsigned char msg[50] = "Sentido: ,velocidade e posicionamento";

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

void motor_init(void);
void PortH_Output(uint32_t data);

void timerInit(void);

void uart_uartInit(void);
unsigned char uart_uartRx(void);
void uart_uartTx(unsigned char txMsg);

///////// LOCAL FUNCTIONS DECLARATIONS //////////

static void Pisca_leds(void);
static void motorRotation(int angulo, char sentido, char velocidade);

///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

int main(void)
{
	unsigned char msg = 0;

	PLL_Init();
	SysTick_Init();
	uart_uartInit();
	GPIO_Init();
	motor_init();
	timerInit();

	// while (1)
	// {
	// 	msg = uart_uartRx();
	// 	uart_uartTx(msg);
	// }

	while (1)
	{
		
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

void initVars(void)
{
	passo =0;
	sysState = 0;
	readState = 0;
	motorPosition = 0;

	return;
}


// Funcao: motorRotation
// Descricao: movimenta o motor de passo mostrando no terminal o sentido, velocidade e em qual posicionamento o motor está se movendo, com resolução de 15°.
// Parametros: angulo - angulo de rotacao
//             sentido - sentido da rotacao (horario ou anti-horario)
//             velocidade - velocidade da rotacao (completo ou meio passo)
// Retorno: void
void motorRotation(char sentido, char velocidade)
{
	// Atraso para estabilização do motor
	SysTick_Wait1ms(2);

	if(velocidade == '1'){
		PortH_Output(meio_passo[passo]);
	}
	else{
		PortH_Output(passo_completo[passo]);
	}

	if(sentido == 'H'){
		passo++;
		if(passo >= 8*velocidade){
			passo = 0;
		}
	}
	else{
		passo--;
		if(passo < 0){
			passo = 8*velocidade - 1;
		}
	}

	contPasso++;
}

void bobina(){
	while()
}

