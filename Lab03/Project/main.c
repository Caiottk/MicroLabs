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

int32_t passo;
int32_t contPasso;
// complete step and middle step for a motor with 1.8° step angle and 2 phases	
uint32_t passo_completo[4] = {0x01, 0x02, 0x04, 0x08};
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

typedef enum EN_MotorSpeed
{
  HALF_STEP,
  FULL_STEP
} EN_MotorSpeed;

typedef struct MotorValues
{
   unsigned char ucAngle[ANGLE_CHAR_SIZE];
   unsigned char ucDirection;
   unsigned char ucSpeed[SPEED_CHAR_SIZE];
   double usAngleVal;
   EN_MotorSpeed usSpeedVal;
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
void PortQ_Output(uint32_t valor);
void PortA_Output(uint32_t valor);
void PortP_Output(uint32_t valor);
void acendeLED(uint16_t led_aceso);

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
static void motorRotation(char sentido, EN_MotorSpeed velocidade);

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
      switch (stStates.ucSysState)
      {
         case SYS_READ_DATA:
         {
            readInput();
         }
         break;

         case SYS_ROTATE_MOTOR:
         {
			Bobina();
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

static void initVars(void)
{
   uart_clearTerminal();

   stStates.ucSysState  = SYS_READ_DATA;
   stStates.ucReadState = READ_ANGLE;

   stMotorValues.usAngleVal  = 0;
   stMotorValues.usSpeedVal  = HALF_STEP;
   stMotorValues.ucDirection = INVALID_NUMBER;

   for (ucIndex = 0; ucIndex < ANGLE_CHAR_SIZE; ucIndex++)
   {
      stMotorValues.ucAngle[ucIndex] = 0;
      stMotorValues.ucSpeed[ucIndex] = 0;
   }

   ucIndex = 0;

   uart_uartTxString("Grau de giro: ", 14);

   return;
}


static void readInput(void)
{
   switch (stStates.ucReadState)
   {
      case READ_ANGLE:
      {
         getAngleChar(&stMotorValues.ucAngle[0], &ucIndex);
      }
      break;

      case READ_DIRECTION:
      {
         getDirectionChar(&stMotorValues.ucDirection);
      }
      break;

      case READ_SPEED:
      {
         getSpeedChar(&stMotorValues.ucSpeed[0], &ucIndex);
      }
      break;

      default:
      {
         // Should never get here
      }
      break;
   }

   return;
}

static void getAngleChar(unsigned char *pucAgleArray, unsigned char *pucIndex)
{
   if (*pucIndex < ANGLE_CHAR_SIZE)
   {
      unsigned char ucRxUartInt = uart_uartRxToInt();
      
      if (INVALID_NUMBER != ucRxUartInt)
      {
         pucAgleArray[*pucIndex] = ucRxUartInt;
         (*pucIndex)++;
         uart_uartTxIntToChar(ucRxUartInt);
      }
   }
   else
   {
      waitForComma();
   }

   return;
}

static void getDirectionChar(unsigned char *pucDirection)
{
   if (INVALID_NUMBER == *pucDirection)
   {
      unsigned char ucRxUartInt = uart_uartRxToInt();

      if (INVALID_NUMBER != ucRxUartInt)
      {
         *pucDirection = ucRxUartInt;
         uart_uartTxIntToChar(ucRxUartInt);
      }
   }
   else
   {
      waitForComma();
   }

   return;
}

static void getSpeedChar(unsigned char *pucSpeedArray, unsigned char *pucIndex)
{
   if (*pucIndex < SPEED_CHAR_SIZE)
   {
      unsigned char ucRxUartInt = uart_uartRxToInt();
      
      if (INVALID_NUMBER != ucRxUartInt)
      {
         pucSpeedArray[*pucIndex] = ucRxUartInt;
         (*pucIndex)++;
         uart_uartTxIntToChar(ucRxUartInt);
      }
   }
   else
   {
      waitForComma();
   }

   return;
}

static void waitForComma(void)
{
   unsigned char ucRxUartChar = uart_uartRx();

   if (',' == ucRxUartChar)
   {
      changeStatesAfterComma();
   }

   return;
}

static void changeStatesAfterComma(void)
{
   if (READ_SPEED == stStates.ucReadState)
   {
      bool bMustRotateMotor = checkMotorValues(&stMotorValues);
      if (true == bMustRotateMotor)
      {
         uart_clearTerminal();
         uart_uartTxString("Motor girando...", 16);
         uart_uartTxString("\n\rPressione algum push_btn para abortar", 39);
         stStates.ucSysState  = SYS_ROTATE_MOTOR;
         stStates.ucReadState = READ_ANGLE;
         ucIndex = 0;
         TIMER2_CTL_R = 1; // Enables timer
      }
      else
      {
         initVars();
      }
   }
   else // Goes to next read state
   {
      stStates.ucReadState = (stStates.ucReadState + 1) % 3;
      ucIndex = 0;

      switch (stStates.ucReadState)
      {
         case READ_DIRECTION:
         {
            uart_uartTxString("\n\rDirecao: ", 11);
         }
         break;

         case READ_SPEED:
         {
            uart_uartTxString("\n\rVelocidade de giro: ", 22);
         }
         break;

         default:
         {
            // Should never get here
         }
         break;
      }
   }

   return;
}

static bool checkMotorValues(MotorValues *pstMotorValues)
{
   bool bMustRotateMotor = true;

   pstMotorValues->usAngleVal = ((pstMotorValues->ucAngle[0] * 100) +
                                 (pstMotorValues->ucAngle[1] * 10)  +
                                 pstMotorValues->ucAngle[2]);
   pstMotorValues->usSpeedVal = ((pstMotorValues->ucSpeed[0] * 100) +
                                 (pstMotorValues->ucSpeed[1] * 10)  +
                                 pstMotorValues->ucSpeed[2]);

   if ((pstMotorValues->usAngleVal  > MAX_ANGLE) ||
       (pstMotorValues->ucDirection > CLOCKWISE) ||
       (pstMotorValues->usSpeedVal  > MAX_SPEED))
   {
      bMustRotateMotor = false;
   }

   return bMustRotateMotor;
}

static void waitForReset(void)
{
   unsigned char ucRxUartChar = uart_uartRx();

   if ('*' == ucRxUartChar)
   {
      initVars();
   }

   return;
}

// Funcao: motorRotation
// Descricao: movimenta o motor de passo mostrando no terminal o sentido, velocidade e em qual posicionamento o motor está se movendo, com resolução de 15°.
// Parametros: angulo - angulo de rotacao
//             sentido - sentido da rotacao (horario ou anti-horario)
//             velocidade - velocidade da rotacao (completo ou meio passo)
// Retorno: void
void motorRotation(char sentido, EN_MotorSpeed velocidade)
{

	int contLed = 0;
   double angulo_rotacionado = 0;
   int auxVelocidade = 0;

   if(velocidade == FULL_STEP){
      auxVelocidade = 2;
   }
   else if(velocidade == HALF_STEP){
      auxVelocidade = 1;
   }


	while(angulo_rotacionado < stMotorValues.usAngleVal){
		SysTick_Wait1ms(2);

		if(velocidade == FULL_STEP){
			PortH_Output(passo_completo[passo]);
		}
		else if(velocidade == HALF_STEP){
			PortH_Output(meio_passo[passo]);
		}

		if(stMotorValues.ucDirection == CLOCKWISE){
			passo++;
			if(passo == 4*auxVelocidade){
				passo = 0;
			}
		}
		else if(stMotorValues.ucDirection == COUNTERCLOCKWISE){
			passo--;
			if(passo == -1){
				passo = 4*auxVelocidade - 1;
			}
		}

		angulo_rotacionado = contPasso * 1.8;

		if(ceil(angulo_rotacionado) %15 == 0){
			msg[8] = sentido;
			msg[10] = velocidade;
			msg[12] = contPasso;
			uart_uartTxString(msg, 50);
		}

		// Verifica se passou um intervalo de 45° para acender o LED
		if(ceil(angulo_rotacionado) %45 == 0 && contLed < 8){
			// Acende o LED correspondente
         contLed++;
			acendeLED(contLed);
		}

	}
	stStates.ucSysState = SYS_WAIT_FOR_RESET;
	return;
}
// Funcao: acendeLED
// Descricao: acende um LED a cada 45° de rotacao e mantem acesos os LEDs anteriores
// 			  também começa acendendo o LED da esquerda para a direita no sentido anti-horario e vice-versa para o sentido horario
// Parametros: led_aceso - LED que sera aceso
// Retorno: void
void acendeLED(uint16_t led_aceso)
{
	switch(led_aceso)
	{
		case 0:
			PortA_Output(0x00);
			PortQ_Output(0x01);
			break;
		case 1:
			PortA_Output(0x00);
			PortQ_Output(0x02);
			break;
		case 2:
			PortA_Output(0x00);
			PortQ_Output(0x04);
			break;		
		case 3:
			PortA_Output(0x00);
			PortQ_Output(0x08);
			break;		
		case 4:
			PortA_Output(0x10);
			PortQ_Output(0x00);
			break;		
		case 5:
			PortA_Output(0x20);
			PortQ_Output(0x00);
			break;		
		case 6:
			PortA_Output(0x40);
			PortQ_Output(0x00);
			break;		
		case 7:
			PortA_Output(0x80);
			PortQ_Output(0x00);
			break;		
		default:
			PortA_Output(0x00);
			PortQ_Output(0x00);
			break;
	}
	PortP_Output(0x20); //aciona transistor
	return;
}

void Bobina()
{
   int contLed = 0, ledHor = 0, ledAnti = 7;
   int auxVelocidade = 0;
   int sentido = 0;
   if(stMotorValues.usSpeedVal == FULL_STEP){
      auxVelocidade = 2;
   }
   else if(stMotorValues.usSpeedVal == HALF_STEP){
      auxVelocidade = 1;
   }

   if(stMotorValues.ucDirection == CLOCKWISE){
      sentido = 1;
   }
   else if(stMotorValues.ucDirection == COUNTERCLOCKWISE){
      sentido = -1;
   }
	while(contPasso < 4*auxVelocidade*stMotorValues.usAngleVal){
		motorRotation(stMotorValues.ucDirection, stMotorValues.usSpeedVal);
      if(contPasso%(15*auxVelocidade)==0){
         msg[8] = stMotorValues.ucDirection;
			msg[10] = stMotorValues.usSpeedVal;
			msg[12] = contPasso;
			uart_uartTxString(msg, 50);
      }
		if(contPasso%(45*auxVelocidade)==0)
		{
			if( contLed == 0 && sentido == -1){
				 ledAnti--;
             contLed = ledAnti;
         }
			else if ( contLed == 7 && sentido == 1){
			    ledHor++;
             contLed = ledHor;
         }
			else 
				contLed += sentido;
		}
      
		Liga_led(contLed);
	}
	Liga_led(10);
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

