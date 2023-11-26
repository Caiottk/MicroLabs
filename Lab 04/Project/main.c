// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"

///////// DEFINES AND MACROS //////////

#define INVALID_ADC_VALUE 0xF000

typedef enum SysState
{
   WAITING_CTRL_MODE,
   WAITING_DIRECTION,
   ROTATING_POTENT_AND_KEY,
   ROTATING_POTENT_ONLY,
} SysState;

typedef enum sentido{
   CLOCKWISE,
   COUNTER_CLOCKWISE,
} Sentido;

typedef enum controle{
   keyboardAndPotent,
   potent
} Controle;

typedef enum bool
{
   false,
   true
} bool;

typedef struct DC_MotorRotation
{
   Sentido dcRotDirection;
   Controle dcRotType;
   uint32_t dcAdVal;
   uint32_t dcPwmPercent;
} DC_MotorRotation;

///////// EXTERNAL FUNCTIONS INCLUSIONS //////////
// Since there is no .h in most files, their functions must be included by hand.
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

extern void adc_adcInit(void);
extern void adc_startAdcConversion(void);

void LCD_GPIOinit();
void LCD_init();
void LCD_printArrayInLcd(char *str);
void LCD_ResetLCD();

void MKBOARD_GPIOinit();
unsigned char MKEYBOARD_readKeyboard();



///////// LOCAL FUNCTIONS DECLARATIONS //////////

/**
 * @brief Initializes all static variables
 */
static void initVars(void);

static void askWayOfMotorCtrl(void);

static void askMotorDirection(void);

static void Pisca_leds(void);

///////// STATIC VARIABLES DECLARATIONS //////////
static SysState sysState;
static DC_MotorRotation dc_MotorRotation;

///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

unsigned long msg = INVALID_ADC_VALUE;

int main(void)
{
   PLL_Init();
   SysTick_Init();
   GPIO_Init();
   LCD_GPIOinit();
   LCD_init();
   MKBOARD_GPIOinit();
   timerInit();
   adc_adcInit();
   initVars();

   while (1)
   {
      switch (sysState)
      {
         case WAITING_CTRL_MODE:
            askWayOfMotorCtrl();
             break;
         case WAITING_DIRECTION:
            askMotorDirection();
            break;
         case ROTATING_POTENT_AND_KEY:
            LCD_ResetLCD();
            break;
         case ROTATING_POTENT_ONLY:
            LCD_ResetLCD();
            break;
         default:
            LCD_ResetLCD();
            break;
      }
   }
}

static void initVars(void)
{
   sysState = WAITING_CTRL_MODE;

   dc_MotorRotation.dcRotDirection = CLOCKWISE;
   dc_MotorRotation.dcRotType = keyboardAndPotent;
   dc_MotorRotation.dcAdVal = INVALID_ADC_VALUE;
   dc_MotorRotation.dcPwmPercent = 0;

   LCD_ResetLCD();
   LCD_printArrayInLcd("Motor parado!");
   SysTick_Wait1ms(1000);

   return;
}

static void askWayOfMotorCtrl(void)
{
   LCD_printArrayInLcd("Controle: 0(KeP) | 1(P)");
   static char c;
   do{
      c = MKEYBOARD_readKeyboard();
   } while(c != '0' && c != '1');
   if(c == '0')
   {
      sysState = WAITING_DIRECTION;
      dc_MotorRotation.dcRotType = keyboardAndPotent;
      LCD_printArrayInLcd("Teclado e Pot");

   }
   else if(c == '1')
   {
      sysState = ROTATING_POTENT_ONLY;
      dc_MotorRotation.dcRotType = potent;
      LCD_printArrayInLcd("Potenciometro");
   }

   SysTick_Wait1ms(1000);

   return;
}

static void askMotorDirection(void)
{
   LCD_printArrayInLcd("Sentido: 0(A) | 1(H)");
   static char c;
   do{
      c = MKEYBOARD_readKeyboard();
   } while(c != '0' && c != '1');
   
   LCD_ResetLCD();
    if(c == '0')
    {
       dc_MotorRotation.dcRotDirection = COUNTER_CLOCKWISE;
       sysState = ROTATING_POTENT_AND_KEY;
       LCD_printArrayInLcd("Anti-horario");
    }
    else if(c == '1')
    {
       dc_MotorRotation.dcRotDirection = CLOCKWISE;
       sysState = ROTATING_POTENT_AND_KEY;
       LCD_printArrayInLcd("Horario");
    }
    SysTick_Wait1ms(1000);

   return;
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

void ADC0Seq3_Handler(void)
{
   msg = ADC0_SSFIFO3_R; // Reads the value from FIFO

   ADC0_DCISC_R = ADC_DCISC_DCINT3; // ACKS the conversion

   ADC0_ISC_R = ADC_ISC_IN3; // ACKS the interruption

   return;
}

void Timer2A_Handler(void)
{
   TIMER2_ICR_R = 1; // ACKS the interruption

   TIMER2_CTL_R = 1; // Enables timer

   return;
}