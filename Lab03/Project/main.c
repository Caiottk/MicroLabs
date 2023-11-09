// main.c
// Developed for EK-TM4C1294XL board
// Authors: Joao Caversan and Caio Andrade

#include <stdint.h>
#include "tm4c1294ncpdt.h"

///////// DEFINES, MACROS AND STRUCTS //////////

#define ANGLE_CHAR_SIZE     3
#define SPEED_CHAR_SIZE     3

#define MAX_ANGLE           360
#define MAX_SPEED           100

#define INVALID_NUMBER 0xFF

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

typedef enum EN_Direction
{
   COUNTERCLOCKWISE,
   CLOCKWISE
} EN_Direction;

typedef enum EN_SysStates
{
   SYS_READ_DATA,
   SYS_ROTATE_MOTOR,
   SYS_WAIT_FOR_RESET
} EN_SysStates;

typedef enum EN_ReadStates
{
   READ_ANGLE,
   READ_DIRECTION,
   READ_SPEED
} EN_ReadStates;

typedef struct States
{
   EN_SysStates  ucSysState;
   EN_ReadStates ucReadState;
} States;

typedef struct MotorValues
{
   unsigned char ucAngle[ANGLE_CHAR_SIZE];
   unsigned char ucDirection;
   unsigned char ucSpeed[SPEED_CHAR_SIZE];
   unsigned short usAngleVal;
   unsigned short usSpeedVal;
} MotorValues;

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
unsigned char uart_uartRxToInt(void);
void uart_uartTx(unsigned char txMsg);
void uart_uartTxString(char *pcString, unsigned char ucStrSize);
void uart_uartTxIntToChar(unsigned char ucNumber);
void uart_clearTerminal(void);

///////// LOCAL FUNCTIONS DECLARATIONS //////////

/**
 * @brief Initializes all static variables
 */
static void initVars(void);

/**
 * @brief Reads the input from the terminal and stores in the correct place
 */
static void readInput(void);

/**
 * @brief Gets a character from the terminal and stores it in pucAgleArray[*pucIndex]
 * 
 * @param pucAgleArray The array where the character will be stored
 * @param pucIndex     The index of the array where the character will be stored
 */
static void getAngleChar(unsigned char *pucAgleArray, unsigned char *pucIndex);

/**
 * @brief Gets the direction from the terminal
 * 
 * @param pucDirection Pointer where the direction will be stored.
 *                     1 -> clockwise, 0 -> counterclockwise
 */
static void getDirectionChar(unsigned char *pucDirection);

/**
 * @brief Gets a character from the terminal and stores it in pucSpeedArray[*pucIndex]
 * 
 * @param pucSpeedArray The array where the character will be stored
 * @param pucIndex      The index of the array where the character will be stored
 */
static void getSpeedChar(unsigned char *pucSpeedArray, unsigned char *pucIndex);

/**
 * @brief waits for the ',' character so that states can be changed
 */
static void waitForComma(void);

/**
 * @brief Changes states after ',' is received
 */
static void changeStatesAfterComma(void);

/**
 * @brief Checks if all values are valid
 * 
 * If yes, ucSysState is changed to 1. If not, all variables are reseted.
 * 
 * @param pstMotorValues Pointer to the struct where the values are stored
 */
static bool checkMotorValues(MotorValues *pstMotorValues);

/**
 * @brief Waits for the '*' character to be received
 * 
 * If received, it resets the system to it's initial state
 */
static void waitForReset(void);

static void Pisca_leds(void);

///////// STATIC VARIABLES DECLARATIONS //////////

static States        stStates;
static MotorValues   stMotorValues;
static unsigned char ucIndex;
static void motorRotation(char sentido, char velocidade);

///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

int main(void)
{
   PLL_Init();
   SysTick_Init();
   uart_uartInit();
   GPIO_Init();
   motor_init();
   timerInit();
   initVars();

	

	while (1)
	{
		
	}
   while (1)
   {
      switch (stStates.ucSysState)
      {
         case SYS_READ_DATA:
         {
            readInput();
         }
         break;

         case SYS_ROTATE_MOTOR:
         {

         }
         break;

         case SYS_WAIT_FOR_RESET:
         {
            waitForReset();
         }
         break;

         default:
         {

         }
         break;
      }
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

   if (SYS_ROTATE_MOTOR == stStates.ucSysState)
   {
      stStates.ucSysState = SYS_WAIT_FOR_RESET;
      uart_clearTerminal();
      uart_uartTxString("Rotacao abortada\n\r", 18);
      uart_uartTxString("Pressione '*' para resetar o sistema", 36);
      GPIO_PORTN_DATA_R &= ~0x3; // Turns off LEDs
      TIMER2_CTL_R       = 0;    // Disables timer
   }

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

