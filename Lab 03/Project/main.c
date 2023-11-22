// main.c
// Developed for EK-TM4C1294XL board
// Authors: Joao Caversan and Caio Andrade

#include <stdint.h>
#include "tm4c1294ncpdt.h"

///////// DEFINES, MACROS AND STRUCTS //////////

#define ANGLE_CHAR_SIZE       3

#define MAX_ANGLE             360
#define MAX_SPEED             100

#define INVALID_NUMBER        0xFF

#define DEGREES_PER_HALF_STEP 0.9

#define CLOCKWISE_SUM         1
#define COUNTERCLOCKWISE_SUM -1

#define HALF_STEPS_FOR_45_DEGREES 50
#define HALF_STEPS_FOR_15_DEGREES 16

// Apparently the compiler doesn't like when I use sizeof()
#define HALF_STEP_ARRAY_SIZE 8

typedef enum bool
{
   false,
   true
} bool;

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
   unsigned char  ucAngle[ANGLE_CHAR_SIZE];
   unsigned char  ucDirection;
   unsigned char  ucSpeedType;
   unsigned short usAngleVal;
   unsigned short usAngleInSteps;
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
void PortE_Output(unsigned long data);

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
static void readInput(MotorValues *pstMotorValues, States *pstStates);

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
 * @brief Gets the type of speed from the terminal
 * 
 * @param pucSpeedType Pointer where the speed type will be stored.
 */
static void getSpeedChar(unsigned char *pucSpeedType);

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
 * @brief Changes all variables so that the rotate state works
 * 
 * @param pstMotorValues Pointer to the struct where motor values are stored
 */
static void changeToRotateState(MotorValues *pstMotorValues, States *pstStates);

/**
 * @brief Sets all variables to their correct values before the reset state
 */
static void changeToResetState(void);

/**
 * @brief Waits for the '*' character to be received
 * 
 * If received, it resets the system to it's initial state
 */
static void waitForReset(void);

static void motorRotation(char sentido, long lSpeedType);

static void rotate(MotorValues *pstMotorValues);

static void Pisca_leds(void);

///////// STATIC VARIABLES DECLARATIONS //////////

static States        stStates;
static MotorValues   stMotorValues;
static unsigned char ucIndex;

int32_t passo;
unsigned short contPasso;

long ledHor = 0;
long ledAnti = 7;
long lSpeedTypeForCalculus = 0;

// complete step and half step for a motor with 1.8° step angle and 2 phases
unsigned long passo_completo[4] = {0x00000008, 0x00000001, 0x00000004, 0x00000002};
unsigned long meio_passo[8]     = {0x00000008, 0x00000009, 0x00000001, 0x00000005,
                                   0x00000004, 0x00000008, 0x00000002, 0x00000008};

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
            readInput(&stMotorValues, &stStates);
         }
         break;

         case SYS_ROTATE_MOTOR:
         {
            rotate(&stMotorValues);
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

   stMotorValues.usAngleVal     = 0;
   stMotorValues.usAngleInSteps = 0;
   stMotorValues.ucDirection    = INVALID_NUMBER;
   stMotorValues.ucSpeedType    = INVALID_NUMBER;
   passo     = 0;
   contPasso = 0;
   ledHor    = 0;
   ledAnti   = 7;

   for (ucIndex = 0; ucIndex < ANGLE_CHAR_SIZE; ucIndex++)
   {
      stMotorValues.ucAngle[ucIndex] = 0;
   }

   ucIndex = 0;

   uart_uartTxString("Grau de giro: ", 14);

   return;
}


static void readInput(MotorValues *pstMotorValues, States *pstStates)
{
   switch (pstStates->ucReadState)
   {
      case READ_ANGLE:
      {
         getAngleChar(&pstMotorValues->ucAngle[0], &ucIndex);
      }
      break;

      case READ_DIRECTION:
      {
         getDirectionChar(&pstMotorValues->ucDirection);
      }
      break;

      case READ_SPEED:
      {
         getSpeedChar(&pstMotorValues->ucSpeedType);
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

static void getSpeedChar(unsigned char *pucSpeedType)
{
   if (INVALID_NUMBER == *pucSpeedType)
   {
      unsigned char ucRxUartInt = uart_uartRxToInt();

      if (INVALID_NUMBER != ucRxUartInt)
      {
         *pucSpeedType = ucRxUartInt;
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
         changeToRotateState(&stMotorValues, &stStates);
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

static void changeToRotateState(MotorValues *pstMotorValues, States *pstStates)
{
   uart_clearTerminal();
   uart_uartTxString("Motor girando...", 16);
   uart_uartTxString("\n\rPressione algum push_btn para abortar", 39);
   pstStates->ucSysState  = SYS_ROTATE_MOTOR;
   pstStates->ucReadState = READ_ANGLE;
   ucIndex = 0;
   TIMER2_CTL_R = 1; // Enables timer
   lSpeedTypeForCalculus = (stMotorValues.ucSpeedType + 1);

   if (COUNTERCLOCKWISE == pstMotorValues->ucDirection)
   {
      if (FULL_STEP == pstMotorValues->ucSpeedType)
      {
         passo = 3;
      }
      else
      {
         passo = 7;
      }
   }
   else
   {
      passo = 0;
   }

   return;
}

static bool checkMotorValues(MotorValues *pstMotorValues)
{
   bool bMustRotateMotor = true;

   pstMotorValues->usAngleVal = (unsigned short)((pstMotorValues->ucAngle[0] * 100) +
                                                 (pstMotorValues->ucAngle[1] * 10)  +
                                                 pstMotorValues->ucAngle[2]);

   pstMotorValues->usAngleInSteps = (unsigned short)((pstMotorValues->usAngleVal) /
                                                     ((pstMotorValues->ucSpeedType + 1) *
                                                      DEGREES_PER_HALF_STEP));

   if ((pstMotorValues->usAngleVal  > MAX_ANGLE) ||
       (pstMotorValues->ucDirection > CLOCKWISE) ||
       (pstMotorValues->ucSpeedType > FULL_STEP))
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
//             lSpeedType - lSpeedType da rotacao (completo ou meio passo) + 1
// Retorno: void
void motorRotation(char sentido, long lSpeedType)
{
   SysTick_Wait1ms(10);

   if (lSpeedType == (FULL_STEP + 1)){
      PortE_Output(passo_completo[passo]);
   }
   else if (lSpeedType == (HALF_STEP + 1)){
      PortE_Output(meio_passo[passo]);
   }

   if (stMotorValues.ucDirection == CLOCKWISE){
      passo++;
      if(passo == (HALF_STEP_ARRAY_SIZE / lSpeedType)){
         passo = 0;
      }
   }
   else if (stMotorValues.ucDirection == COUNTERCLOCKWISE){
      passo--;
      if(passo == -1){
         passo = (HALF_STEP_ARRAY_SIZE / lSpeedType) - 1;
      }
   }

   contPasso++;

   return;
}

// Funcao: acendeLED
// Descricao: acende um LED a cada 45° de rotacao e mantem acesos os LEDs anteriores
//            também começa acendendo o LED da esquerda para a direita no sentido anti-horario e vice-versa para o sentido horario
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

static void rotate(MotorValues *pstMotorValues)
{
   if (contPasso < pstMotorValues->usAngleInSteps)
   {
      motorRotation(pstMotorValues->ucDirection, lSpeedTypeForCalculus);

      if ((contPasso % (HALF_STEPS_FOR_15_DEGREES / lSpeedTypeForCalculus)) == 0) // When the angle is a multiple of 15°
      {
         uart_uartTxString("\r\nSentido: ", 11);
         uart_uartTxIntToChar(pstMotorValues->ucDirection);
         uart_uartTxString("\r\nTipo de velocidade: ", 22);
         uart_uartTxIntToChar(pstMotorValues->ucSpeedType);
         uart_uartTxString("\r\nPassos dados: ", 16);
         uart_uartTxIntToChar((unsigned char)(contPasso / 100));
         uart_uartTxIntToChar((unsigned char)((contPasso / 10) - ((contPasso / 100) * 10)));
         uart_uartTxIntToChar((unsigned char)(contPasso % 10));
         uart_uartTxString("\r\n", 2);
      }

      if ((contPasso % (HALF_STEPS_FOR_45_DEGREES / lSpeedTypeForCalculus)) == 0) // When the angle is a multiple of 45°
      {
         if (CLOCKWISE == pstMotorValues->ucDirection)
         {
            acendeLED(ledHor);
            ledHor++;
         }
         else // if (COUNTERCLOCKWISE == stMotorValues.ucDirection)
         {
            acendeLED(ledAnti);
            ledAnti--;
         }
      }
   }
   else
   {
      acendeLED(10);
      changeToResetState();
   }

   return;
}

static void changeToResetState(void)
{
   stStates.ucSysState = SYS_WAIT_FOR_RESET;
   uart_clearTerminal();
   uart_uartTxString("Rotacao finalizada\n\r", 20);
   uart_uartTxString("Pressione '*' para resetar o sistema", 36);
   GPIO_PORTN_DATA_R &= ~0x3; // Turns off LEDs
   TIMER2_CTL_R       = 0;    // Disables timer
}

///////// HANDLERS IMPLEMENTATIONS //////////

void GPIOPortJ_Handler(void)
{
   GPIO_PORTJ_AHB_ICR_R = 0x3;

   if (SYS_ROTATE_MOTOR == stStates.ucSysState)
   {
      changeToResetState();
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

