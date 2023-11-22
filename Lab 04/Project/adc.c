#include <stdint.h>
#include "tm4c1294ncpdt.h"

extern void adc_adcInit(void);
extern void adc_startAdcConversion(void);

/**
 * @brief Initializes the SS3 sequencer of ADC0 as an interruption
 */
extern void adc_adcInit(void)
{
   SYSCTL_RCGCADC_R = SYSCTL_RCGCADC_R0; // Enables clk

   // Waits for clock to be ready
   while ((SYSCTL_PRADC_R & SYSCTL_PRADC_R0) != SYSCTL_PRADC_R0) { } 

   ADC0_PC_R = 0x7; // Max conversion rate

   ADC0_SSPRI_R = 0x0; // No priority, since there is only one sequencer

   ADC0_ACTSS_R = 0x0; // ASEN3 = 0

   ADC0_EMUX_R = ADC_EMUX_EM3_PROCESSOR; // Processor trigger event -> ADC0_PSSI = 0x8 for SS3

   ADC0_SSMUX3_R = 0x00000009; // AIN9 (PE3) 

   ADC0_SSCTL3_R = ADC_SSCTL3_IE0 | ADC_SSCTL3_END0; // Interrupt enable and end of sequence

   ADC0_IM_R = ADC_IM_MASK3; // Interrupt mask

   ADC0_ACTSS_R |= ADC_ACTSS_ASEN3; // Enables sequencer 3

   ADC0_ISC_R = ADC_ISC_IN3; // ACKS the interruption

   // Enable interrut in Nvic
   NVIC_EN0_R |= (1 << 17); // ADC0 sequence number 3

   // Set port interrupt priority
   NVIC_PRI4_R = (0x1 << 13);

   return;
}

extern void adc_startAdcConversion(void)
{
	ADC0_PSSI_R = ADC_PSSI_SS3; // Starts conversion

	return;
}