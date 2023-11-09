
#include "tm4c1294ncpdt.h"
#include <stdint.h>

#define GPIO_PORTH 0x80 //bit 7

void motor_init(void){
    // clk da porta
    SYSCTL_RCGCGPIO_R |= GPIO_PORTH;

    // espera porta estar pronta
    while((SYSCTL_PRGPIO_R & GPIO_PORTH) != GPIO_PORTH){};
    
    // 2. Limpar o AMSEL para desabilitar a analogica
    GPIO_PORTH_AHB_AMSEL_R = 0x00;

    // 3. Limpar PCTL para selecionar o GPIO
    GPIO_PORTH_AHB_PCTL_R = 0x00;

    // 4. DIR para 0 se for entrada, 1 se for saida
    GPIO_PORTH_AHB_DIR_R = 0x0F;

    // 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
    GPIO_PORTH_AHB_AFSEL_R = 0x00;

    // 6. Setar os bits de DEN para habilitar I/O digital
    GPIO_PORTH_AHB_DEN_R = 0x0F;

    return;
}

extern void PortH_Output(uint32_t data){
    uint32_t temp;
    temp = GPIO_PORTH_AHB_DATA_R & 0xF0;
    temp = temp | data;
    GPIO_PORTH_AHB_DATA_R = temp;
    return;
}   


