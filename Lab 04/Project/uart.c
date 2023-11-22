// UART bus initialization

#include <stdint.h>
#include "tm4c1294ncpdt.h"

#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTN  (0x1000) //bit 12
#define GPIO_PORTF  (0x0020) // bit 5

/////// EXTERNABLE FUNCTIONS DECLARATION ///////

/**
 * @brief Initializes all UART registers
 */
extern void uart_uartInit(void);

/**
 * @brief Receives data from UART0 if the queue is not empty
 * 
 * @return unsigned char The byte received
 */
extern unsigned char uart_uartRx(void);

/**
 * @brief Transmits data to UART0 if the queue is not full and txMsg differs from 0
 * 
 * @param txMsg The byte to be sent
 */
extern void uart_uartTx(unsigned char txMsg);

/////// EXTERNABLE FUNCTIONS IMPLEMENTATION ///////

extern void uart_uartInit(void)
{
   // UART SETTINGS
   SYSCTL_RCGCUART_R = SYSCTL_RCGCUART_R0; // Enables clk

   while ((SYSCTL_PRUART_R & SYSCTL_PRUART_R0) != SYSCTL_PRUART_R0) { } // Waits for clock to be ready

   UART0_CTL_R = UART0_CTL_R & (~UART_CTL_UARTEN); // Disables uart0 by setting uarten to 0

   UART0_IBRD_R = 260; // Magic numbers from slide show -> sysclock/(clkDiv * BaudRate) = 80M/(16*19200)
   UART0_FBRD_R = 27; // round(Decimal number * 64)

   UART0_LCRH_R = 0x7A; // WLEN = 11, FEN = 1, STP2 = 1, EPS = 0, PEN = 1

   UART0_CC_R = 0; // CLK = sysCLK

   UART0_CTL_R = (UART_CTL_UARTEN | UART_CTL_TXE | UART_CTL_RXE); // Enables Tx, Rx, HSE=0 (clkDiv = 16) and UARTEN

   return;
}

extern unsigned char uart_uartRx(void)
{
	unsigned char rxMsg = 0;
	unsigned long isRxQueueEmpty = (UART0_FR_R & UART_FR_RXFE) >> 4;

	if (0 == isRxQueueEmpty)
	{
		rxMsg = UART0_DR_R;
	}

	return rxMsg;
}

extern void uart_uartTx(unsigned char txMsg)
{
	unsigned long isTxQueueFull = (UART0_FR_R & UART_FR_TXFF) >> 5;

	if ((0 == isTxQueueFull) && (0 != txMsg))
	{
		UART0_DR_R = txMsg;
	}

	return;
}