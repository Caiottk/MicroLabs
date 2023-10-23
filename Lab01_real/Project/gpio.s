; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT A
GPIO_PORTA_AHB_DATA_BITS_R  EQU 0x40058000
GPIO_PORTA_AHB_DATA_R       EQU 0x400583FC
GPIO_PORTA_AHB_DIR_R        EQU 0x40058400
GPIO_PORTA_AHB_IS_R         EQU 0x40058404
GPIO_PORTA_AHB_IBE_R        EQU 0x40058408
GPIO_PORTA_AHB_IEV_R        EQU 0x4005840C
GPIO_PORTA_AHB_IM_R         EQU 0x40058410
GPIO_PORTA_AHB_RIS_R        EQU 0x40058414
GPIO_PORTA_AHB_MIS_R        EQU 0x40058418
GPIO_PORTA_AHB_ICR_R        EQU 0x4005841C
GPIO_PORTA_AHB_AFSEL_R      EQU 0x40058420
GPIO_PORTA_AHB_DR2R_R       EQU 0x40058500
GPIO_PORTA_AHB_DR4R_R       EQU 0x40058504
GPIO_PORTA_AHB_DR8R_R       EQU 0x40058508
GPIO_PORTA_AHB_ODR_R        EQU 0x4005850C
GPIO_PORTA_AHB_PUR_R        EQU 0x40058510
GPIO_PORTA_AHB_PDR_R        EQU 0x40058514
GPIO_PORTA_AHB_SLR_R        EQU 0x40058518
GPIO_PORTA_AHB_DEN_R        EQU 0x4005851C
GPIO_PORTA_AHB_LOCK_R       EQU 0x40058520
GPIO_PORTA_AHB_CR_R         EQU 0x40058524
GPIO_PORTA_AHB_AMSEL_R      EQU 0x40058528
GPIO_PORTA_AHB_PCTL_R       EQU 0x4005852C
GPIO_PORTA_AHB_ADCCTL_R     EQU 0x40058530
GPIO_PORTA_AHB_DMACTL_R     EQU 0x40058534
GPIO_PORTA_AHB_SI_R         EQU 0x40058538
GPIO_PORTA_AHB_DR12R_R      EQU 0x4005853C
GPIO_PORTA_AHB_WAKEPEN_R    EQU 0x40058540
GPIO_PORTA_AHB_WAKELVL_R    EQU 0x40058544
GPIO_PORTA_AHB_WAKESTAT_R   EQU 0x40058548
GPIO_PORTA_AHB_PP_R         EQU 0x40058FC0
GPIO_PORTA_AHB_PC_R         EQU 0x40058FC4
GPIO_PORTA               	EQU 2_000000000000001
; PORT B
GPIO_PORTB_AHB_DATA_BITS_R  EQU 0x40059000
GPIO_PORTB_AHB_DATA_R       EQU 0x400593FC
GPIO_PORTB_AHB_DIR_R        EQU 0x40059400
GPIO_PORTB_AHB_IS_R         EQU 0x40059404
GPIO_PORTB_AHB_IBE_R        EQU 0x40059408
GPIO_PORTB_AHB_IEV_R        EQU 0x4005940C
GPIO_PORTB_AHB_IM_R         EQU 0x40059410
GPIO_PORTB_AHB_RIS_R        EQU 0x40059414
GPIO_PORTB_AHB_MIS_R        EQU 0x40059418
GPIO_PORTB_AHB_ICR_R        EQU 0x4005941C
GPIO_PORTB_AHB_AFSEL_R      EQU 0x40059420
GPIO_PORTB_AHB_DR2R_R       EQU 0x40059500
GPIO_PORTB_AHB_DR4R_R       EQU 0x40059504
GPIO_PORTB_AHB_DR8R_R       EQU 0x40059508
GPIO_PORTB_AHB_ODR_R        EQU 0x4005950C
GPIO_PORTB_AHB_PUR_R        EQU 0x40059510
GPIO_PORTB_AHB_PDR_R        EQU 0x40059514
GPIO_PORTB_AHB_SLR_R        EQU 0x40059518
GPIO_PORTB_AHB_DEN_R        EQU 0x4005951C
GPIO_PORTB_AHB_LOCK_R       EQU 0x40059520
GPIO_PORTB_AHB_CR_R         EQU 0x40059524
GPIO_PORTB_AHB_AMSEL_R      EQU 0x40059528
GPIO_PORTB_AHB_PCTL_R       EQU 0x4005952C
GPIO_PORTB_AHB_ADCCTL_R     EQU 0x40059530
GPIO_PORTB_AHB_DMACTL_R     EQU 0x40059534
GPIO_PORTB_AHB_SI_R         EQU 0x40059538
GPIO_PORTB_AHB_DR12R_R      EQU 0x4005953C
GPIO_PORTB_AHB_WAKEPEN_R    EQU 0x40059540
GPIO_PORTB_AHB_WAKELVL_R    EQU 0x40059544
GPIO_PORTB_AHB_WAKESTAT_R   EQU 0x40059548
GPIO_PORTB_AHB_PP_R         EQU 0x40059FC0
GPIO_PORTB_AHB_PC_R         EQU 0x40059FC4
GPIO_PORTB				    EQU 2_000000000000010
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000
; PORT P
GPIO_PORTP_DATA_BITS_R  EQU     0x40065000
GPIO_PORTP_DATA_R       EQU     0x400653FC
GPIO_PORTP_DIR_R        EQU     0x40065400
GPIO_PORTP_IS_R         EQU     0x40065404
GPIO_PORTP_IBE_R        EQU     0x40065408
GPIO_PORTP_IEV_R        EQU     0x4006540C
GPIO_PORTP_IM_R         EQU     0x40065410
GPIO_PORTP_RIS_R        EQU     0x40065414
GPIO_PORTP_MIS_R        EQU     0x40065418
GPIO_PORTP_ICR_R        EQU     0x4006541C
GPIO_PORTP_AFSEL_R      EQU     0x40065420
GPIO_PORTP_DR2R_R       EQU     0x40065500
GPIO_PORTP_DR4R_R       EQU     0x40065504
GPIO_PORTP_DR8R_R       EQU     0x40065508
GPIO_PORTP_ODR_R        EQU     0x4006550C
GPIO_PORTP_PUR_R        EQU     0x40065510
GPIO_PORTP_PDR_R        EQU     0x40065514
GPIO_PORTP_SLR_R        EQU     0x40065518
GPIO_PORTP_DEN_R        EQU     0x4006551C
GPIO_PORTP_LOCK_R       EQU     0x40065520
GPIO_PORTP_CR_R         EQU     0x40065524
GPIO_PORTP_AMSEL_R      EQU     0x40065528
GPIO_PORTP_PCTL_R       EQU     0x4006552C
GPIO_PORTP_ADCCTL_R     EQU     0x40065530
GPIO_PORTP_DMACTL_R     EQU     0x40065534
GPIO_PORTP_SI_R         EQU     0x40065538
GPIO_PORTP_DR12R_R      EQU     0x4006553C
GPIO_PORTP_WAKEPEN_R    EQU     0x40065540
GPIO_PORTP_WAKELVL_R    EQU     0x40065544
GPIO_PORTP_WAKESTAT_R   EQU     0x40065548
GPIO_PORTP_PP_R         EQU     0x40065FC0
GPIO_PORTP_PC_R         EQU     0x40065FC4
GPIO_PORTP				EQU 	2_010000000000000
; PORT Q
GPIO_PORTQ_DATA_BITS_R  EQU     0x40066000
GPIO_PORTQ_DATA_R       EQU     0x400663FC
GPIO_PORTQ_DIR_R        EQU     0x40066400
GPIO_PORTQ_IS_R         EQU     0x40066404
GPIO_PORTQ_IBE_R        EQU     0x40066408
GPIO_PORTQ_IEV_R        EQU     0x4006640C
GPIO_PORTQ_IM_R         EQU     0x40066410
GPIO_PORTQ_RIS_R        EQU     0x40066414
GPIO_PORTQ_MIS_R        EQU     0x40066418
GPIO_PORTQ_ICR_R        EQU     0x4006641C
GPIO_PORTQ_AFSEL_R      EQU     0x40066420
GPIO_PORTQ_DR2R_R       EQU     0x40066500
GPIO_PORTQ_DR4R_R       EQU     0x40066504
GPIO_PORTQ_DR8R_R       EQU     0x40066508
GPIO_PORTQ_ODR_R        EQU     0x4006650C
GPIO_PORTQ_PUR_R        EQU     0x40066510
GPIO_PORTQ_PDR_R        EQU     0x40066514
GPIO_PORTQ_SLR_R        EQU     0x40066518
GPIO_PORTQ_DEN_R        EQU     0x4006651C
GPIO_PORTQ_LOCK_R       EQU     0x40066520
GPIO_PORTQ_CR_R         EQU     0x40066524
GPIO_PORTQ_AMSEL_R      EQU     0x40066528
GPIO_PORTQ_PCTL_R       EQU     0x4006652C
GPIO_PORTQ_ADCCTL_R     EQU     0x40066530
GPIO_PORTQ_DMACTL_R     EQU     0x40066534
GPIO_PORTQ_SI_R         EQU     0x40066538
GPIO_PORTQ_DR12R_R      EQU     0x4006653C
GPIO_PORTQ_WAKEPEN_R    EQU     0x40066540
GPIO_PORTQ_WAKELVL_R    EQU     0x40066544
GPIO_PORTQ_WAKESTAT_R   EQU     0x40066548
GPIO_PORTQ_PP_R         EQU     0x40066FC0
GPIO_PORTQ_PC_R         EQU     0x40066FC4
GPIO_PORTQ				EQU 	2_100000000000000


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT LightUp7SegLeft
		EXPORT LightUp7SegRight
		EXPORT LightUpLEDs			; Permite chamar LightUpLEDs de outro arquivo
		EXPORT GetPushBtnsState     ; Permite chamar GetPushBtnsState de outro arquivo
		EXPORT DisableAllLEDs
							
		IMPORT SysTick_Wait1ms
		IMPORT  SysTick_Wait1us

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================

			LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTN                 ;Seta o bit da porta N
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTA
			ORR		R1, #GPIO_PORTB
			ORR 	R1, #GPIO_PORTP
			ORR 	R1, #GPIO_PORTQ
			STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO

			LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTN                 ;Seta os bits correspondentes às portas para fazer a comparação
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
			ORR		R2, #GPIO_PORTA
			ORR		R1, #GPIO_PORTB
			ORR 	R1, #GPIO_PORTP
			ORR 	R2, #GPIO_PORTQ
			TST     R1, R2							;ANDS de R1 com R2
			BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando

		; 2. Limpar o AMSEL para desabilitar a analógica
			MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
			LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
			STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
			LDR     R0, =GPIO_PORTN_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta N
			STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da memória
			LDR		R0, =GPIO_PORTA_AHB_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTB_AHB_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTP_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTQ_AMSEL_R
			STR     R1, [R0]

		; 3. Limpar PCTL para selecionar o GPIO
			MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
			LDR     R0, =GPIO_PORTN_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta N
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
			LDR     R0, =GPIO_PORTA_AHB_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTB_AHB_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTQ_PCTL_R
			STR     R1, [R0]
		; 4. DIR para 0 se for entrada, 1 se for saída
			LDR     R0, =GPIO_PORTN_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta N
			MOV     R1, #2_00000010					;PN1 para LED
			STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PF para não transformar entradas em saídas desnecessárias
			LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
			MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com saída
			STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
			LDR     R0, =GPIO_PORTA_AHB_DIR_R
			MOV     R1, #2_11110000			
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTB_AHB_DIR_R
			MOV     R1, #2_110000			
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_DIR_R
			MOV     R1, #2_00100000
			STR     R1, [R0]			
			LDR     R0, =GPIO_PORTQ_DIR_R
			MOV     R1, #2_00001111			
			STR     R1, [R0]				
		; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
		;    Sem função alternativa
			MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
			LDR     R0, =GPIO_PORTN_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta N
			STR     R1, [R0]						;Escreve na porta
			LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
			STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTA_AHB_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTB_AHB_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTP_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTQ_AFSEL_R
			STR		R1, [R0]
		; 6. Setar os bits de DEN para habilitar I/O digital
			LDR     R0, =GPIO_PORTN_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_000000010                     ;Ativa os pinos PN1 como I/O Digital
			STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 

			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0  como I/O Digital      
			STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_PORTA_AHB_DEN_R
			MOV     R1, #2_11110000
			STR 	R1, [R0]
			
			LDR     R0, =GPIO_PORTB_AHB_DEN_R
			MOV     R1, #2_110000
			STR 	R1, [R0]
			
			LDR     R0, =GPIO_PORTP_DEN_R
			MOV     R1, #2_00100000
			STR 	R1, [R0]
			
			LDR     R0, =GPIO_PORTQ_DEN_R
			MOV     R1, #2_00001111
			STR 	R1, [R0]
			
		; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
														;nos bits 0 e 1
			STR     R1, [R0]	

			BX LR



; -------------------------------------------------------------------------------
; Função LightUp7SegLeft
; Parâmetro de entrada: R0: numero de 1 a 8 para ser aceso no display esquerdo
; Parâmetro de saída: Não tem
LightUp7SegLeft
	; Enables left 7-segment Display
	LDR R9, =GPIO_PORTB_AHB_DATA_R
	MOV R8, #2_010000
	STR R8, [R9]
	B LightUp7SegDisplay
; -------------------------------------------------------------------------------
; Função LightUp7SegRight
; Parâmetro de entrada: R0: numero de 1 a 8 para ser aceso no display direito
; Parâmetro de saída: Não tem
LightUp7SegRight
	; Enables right 7-segment Display
	LDR R9, =GPIO_PORTB_AHB_DATA_R
	MOV R8, #2_100000
	STR R8, [R9]
	B LightUp7SegDisplay

; -------------------------------------------------------------------------------
; Função LightUp7SegDisplay
; Parâmetro de entrada: R0: numero de 0 a 9 para ser aceso em um dos displays
; Parâmetro de saída: Não tem
LightUp7SegDisplay
	; Disables LEDs
	LDR R9, =GPIO_PORTP_DATA_R
	MOV R8, #2_000000
	STR R8, [R9]
	
	LDR	R7, =2_00000000
	LDR	R6, =2_00000000
	
	CMP R0, #0x0
	ITTT EQ
		LDREQ	R7, =2_00110000
		LDREQ	R6, =2_00001111
		BEQ 	let7SegShine	
	CMP R0, #0x1
	ITT EQ
		LDREQ	R6, =2_00000110
		BEQ 	let7SegShine		
	CMP R0, #0x2
	ITTT EQ
		LDREQ	R7, =2_01010000
		LDREQ	R6, =2_00001011
		BEQ 	let7SegShine
	CMP R0, #0x3
	ITTT EQ
		LDREQ	R7, =2_01000000
		LDREQ	R6, =2_00001111
		BEQ 	let7SegShine
	CMP R0, #0x4
	ITTT EQ
		LDREQ	R7, =2_01100000
		LDREQ	R6, =2_00000110
		BEQ 	let7SegShine
	CMP R0, #0x5
	ITTT EQ
		LDREQ	R7, =2_01100000
		LDREQ	R6, =2_00001101
		BEQ 	let7SegShine
	CMP R0, #0x6
	ITTT EQ
		LDREQ	R7, =2_01110000
		LDREQ	R6, =2_00001101
		BEQ 	let7SegShine
	CMP R0, #0x7
	ITT EQ
		LDREQ	R6, =2_00000111
		BEQ 	let7SegShine
	CMP R0, #0x8
	ITTT EQ
		LDREQ	R7, =2_01110000
		LDREQ	R6, =2_00001111
		BEQ 	let7SegShine
	CMP R0, #0x9
	ITTT EQ
		LDREQ	R7, =2_01100000
		LDREQ	R6, =2_00001111
		BEQ 	let7SegShine
		
	; Lights up the 7 segments displays
let7SegShine
	LDR R9, =GPIO_PORTA_AHB_DATA_R
	STR R7, [R9]
	LDR R8, =GPIO_PORTQ_DATA_R
	STR R6, [R8]
	
	BX LR
	
; -------------------------------------------------------------------------------
; Função LightUpLEDs
; Parâmetro de entrada: R0: numero de 1 a 8 para ser aceso nos LEDs
; Parâmetro de saída: Não tem
LightUpLEDs
	; Disables 7-segment Displays
	LDR R9, =GPIO_PORTB_AHB_DATA_R
	MOV R8, #2_000000
	STR R8, [R9]
	; Enables LEDs
	LDR R9, =GPIO_PORTP_DATA_R
	MOV R8, #2_100000
	STR R8, [R9]
	
	LDR	R6, =2_00000000
	LDR	R7, =2_00000000
	
	CMP R0, #0x1
	ITT	EQ
		LDREQ	R7, =2_10000000
		BEQ 	letThemShine		
	CMP R0, #0x2
	ITT	EQ
		LDREQ	R7, =2_11000000
		BEQ 	letThemShine
	CMP R0, #0x3
	ITT EQ
		LDREQ	R7, =2_11100000
		BEQ 	letThemShine
	CMP R0, #0x4
	ITT EQ
		LDREQ	R7, =2_11110000
		BEQ 	letThemShine
	CMP R0, #0x5
	ITTT EQ
		LDREQ	R7, =2_11110000
		LDREQ	R6, =2_00001000
		BEQ 	letThemShine
	CMP R0, #0x6
	ITTT EQ
		LDREQ	R7, =2_11110000
		LDREQ	R6, =2_00001100
		BEQ 	letThemShine
	CMP R0, #0x7
	ITTT EQ
		LDREQ	R7, =2_11110000
		LDREQ	R6, =2_00001110
		BEQ 	letThemShine
	CMP R0, #0x8
	ITTT EQ
		LDREQ	R7, =2_11110000
		LDREQ	R6, =2_00001111
		BEQ 	letThemShine
		
	; Lights up the LEDs
letThemShine
	LDR R9, =GPIO_PORTA_AHB_DATA_R
	STR R7, [R9]
	LDR R8, =GPIO_PORTQ_DATA_R
	STR R6, [R8]
	
	BX LR
; -------------------------------------------------------------------------------
; Função GetPushBtnsState
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
GetPushBtnsState
	LDR R9, =GPIO_PORTJ_AHB_DATA_R
	LDR R0, [R9]
	
	BX LR

; -------------------------------------------------------------------------------
; Função DisableAllLEDs
; Parâmetro de entrada: R0: numero de 1 a 8 para ser aceso nos LEDs
; Parâmetro de saída: Não tem
DisableAllLEDs
	; Disables 7-segment Displays
	LDR R9, =GPIO_PORTB_AHB_DATA_R
	MOV R8, #2_000000
	STR R8, [R9]
	; Disables LEDs
	LDR R9, =GPIO_PORTP_DATA_R
	MOV R8, #2_000000
	STR R8, [R9]
	
	BX LR

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo