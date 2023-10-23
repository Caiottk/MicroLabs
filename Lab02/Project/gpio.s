; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; NVIC defines
NVIC_EN1_R			EQU 0xE000E104
NVIC_PRI12_R		EQU 0xE000E430
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
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
GPIO_PORTJ_AHB_IM_R     	EQU 0x40060410	
GPIO_PORTJ_AHB_IS_R			EQU 0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU 0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU 0x4006040C
GPIO_PORTJ_AHB_ICR_R    	EQU 0x4006041C
GPIO_PORTJ_AHB_RIS_R		EQU 0x40060414
GPIO_PORTJ               	EQU    2_000000100000000
;PORT K
GPIO_PORTK_DATA_BITS_R  EQU 0x40061000
GPIO_PORTK_DATA_R       EQU 0x400613FC
GPIO_PORTK_DIR_R        EQU 0x40061400
GPIO_PORTK_IS_R         EQU 0x40061404
GPIO_PORTK_IBE_R        EQU 0x40061408
GPIO_PORTK_IEV_R        EQU 0x4006140C
GPIO_PORTK_IM_R         EQU 0x40061410
GPIO_PORTK_RIS_R        EQU 0x40061414
GPIO_PORTK_MIS_R        EQU 0x40061418
GPIO_PORTK_ICR_R        EQU 0x4006141C
GPIO_PORTK_AFSEL_R      EQU 0x40061420
GPIO_PORTK_DR2R_R       EQU 0x40061500
GPIO_PORTK_DR4R_R       EQU 0x40061504
GPIO_PORTK_DR8R_R       EQU 0x40061508
GPIO_PORTK_ODR_R        EQU 0x4006150C
GPIO_PORTK_PUR_R        EQU 0x40061510
GPIO_PORTK_PDR_R        EQU 0x40061514
GPIO_PORTK_SLR_R        EQU 0x40061518
GPIO_PORTK_DEN_R        EQU 0x4006151C
GPIO_PORTK_LOCK_R       EQU 0x40061520
GPIO_PORTK_CR_R         EQU 0x40061524
GPIO_PORTK_AMSEL_R      EQU 0x40061528
GPIO_PORTK_PCTL_R       EQU 0x4006152C
GPIO_PORTK_ADCCTL_R     EQU 0x40061530
GPIO_PORTK_DMACTL_R     EQU 0x40061534
GPIO_PORTK_SI_R         EQU 0x40061538
GPIO_PORTK_DR12R_R      EQU 0x4006153C
GPIO_PORTK_WAKEPEN_R    EQU 0x40061540
GPIO_PORTK_WAKELVL_R    EQU 0x40061544
GPIO_PORTK_WAKESTAT_R   EQU 0x40061548
GPIO_PORTK_PP_R         EQU 0x40061FC0
GPIO_PORTK_PC_R         EQU 0x40061FC4
GPIO_PORTK              EQU 2_000001000000000
	
;PORT L
GPIO_PORTL_DATA_BITS_R  EQU 0x40062000
GPIO_PORTL_DATA_R       EQU 0x400623FC
GPIO_PORTL_DIR_R        EQU 0x40062400
GPIO_PORTL_IS_R         EQU 0x40062404
GPIO_PORTL_IBE_R        EQU 0x40062408
GPIO_PORTL_IEV_R        EQU 0x4006240C
GPIO_PORTL_IM_R         EQU 0x40062410
GPIO_PORTL_RIS_R        EQU 0x40062414
GPIO_PORTL_MIS_R        EQU 0x40062418
GPIO_PORTL_ICR_R        EQU 0x4006241C
GPIO_PORTL_AFSEL_R      EQU 0x40062420
GPIO_PORTL_DR2R_R       EQU 0x40062500
GPIO_PORTL_DR4R_R       EQU 0x40062504
GPIO_PORTL_DR8R_R       EQU 0x40062508
GPIO_PORTL_ODR_R        EQU 0x4006250C
GPIO_PORTL_PUR_R        EQU 0x40062510
GPIO_PORTL_PDR_R        EQU 0x40062514
GPIO_PORTL_SLR_R        EQU 0x40062518
GPIO_PORTL_DEN_R        EQU 0x4006251C
GPIO_PORTL_LOCK_R       EQU 0x40062520
GPIO_PORTL_CR_R         EQU 0x40062524
GPIO_PORTL_AMSEL_R      EQU 0x40062528
GPIO_PORTL_PCTL_R       EQU 0x4006252C
GPIO_PORTL_ADCCTL_R     EQU 0x40062530
GPIO_PORTL_DMACTL_R     EQU 0x40062534
GPIO_PORTL_SI_R         EQU 0x40062538
GPIO_PORTL_DR12R_R      EQU 0x4006253C
GPIO_PORTL_WAKEPEN_R    EQU 0x40062540
GPIO_PORTL_WAKELVL_R    EQU 0x40062544
GPIO_PORTL_WAKESTAT_R   EQU 0x40062548
GPIO_PORTL_PP_R         EQU 0x40062FC0
GPIO_PORTL_PC_R         EQU 0x40062FC4
GPIO_PORTL              EQU 2_000010000000000

; PORT M
GPIO_PORTM_DATA_BITS_R  EQU 0x40063000
GPIO_PORTM_DATA_R       EQU 0x400633FC
GPIO_PORTM_DIR_R        EQU 0x40063400
GPIO_PORTM_IS_R         EQU 0x40063404
GPIO_PORTM_IBE_R        EQU 0x40063408
GPIO_PORTM_IEV_R        EQU 0x4006340C
GPIO_PORTM_IM_R         EQU 0x40063410
GPIO_PORTM_RIS_R        EQU 0x40063414
GPIO_PORTM_MIS_R        EQU 0x40063418
GPIO_PORTM_ICR_R        EQU 0x4006341C
GPIO_PORTM_AFSEL_R      EQU 0x40063420
GPIO_PORTM_DR2R_R       EQU 0x40063500
GPIO_PORTM_DR4R_R       EQU 0x40063504
GPIO_PORTM_DR8R_R       EQU 0x40063508
GPIO_PORTM_ODR_R        EQU 0x4006350C
GPIO_PORTM_PUR_R        EQU 0x40063510
GPIO_PORTM_PDR_R        EQU 0x40063514
GPIO_PORTM_SLR_R        EQU 0x40063518
GPIO_PORTM_DEN_R        EQU 0x4006351C
GPIO_PORTM_LOCK_R       EQU 0x40063520
GPIO_PORTM_CR_R         EQU 0x40063524
GPIO_PORTM_AMSEL_R      EQU 0x40063528
GPIO_PORTM_PCTL_R       EQU 0x4006352C
GPIO_PORTM_ADCCTL_R     EQU 0x40063530
GPIO_PORTM_DMACTL_R     EQU 0x40063534
GPIO_PORTM_SI_R         EQU 0x40063538
GPIO_PORTM_DR12R_R      EQU 0x4006353C
GPIO_PORTM_WAKEPEN_R    EQU 0x40063540
GPIO_PORTM_WAKELVL_R    EQU 0x40063544
GPIO_PORTM_WAKESTAT_R   EQU 0x40063548
GPIO_PORTM_PP_R         EQU 0x40063FC0
GPIO_PORTM_PC_R         EQU 0x40063FC4
GPIO_PORTM              EQU 2_000100000000000
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
GPIO_PORTP_DATA_BITS_R  	EQU     0x40065000
GPIO_PORTP_DATA_R       	EQU     0x400653FC
GPIO_PORTP_DIR_R       		EQU     0x40065400
GPIO_PORTP_IS_R        		EQU     0x40065404
GPIO_PORTP_IBE_R      	  	EQU     0x40065408
GPIO_PORTP_IEV_R      	  	EQU     0x4006540C
GPIO_PORTP_IM_R        	 	EQU     0x40065410
GPIO_PORTP_RIS_R        	EQU     0x40065414
GPIO_PORTP_MIS_R        	EQU     0x40065418
GPIO_PORTP_ICR_R        	EQU     0x4006541C
GPIO_PORTP_AFSEL_R      	EQU     0x40065420
GPIO_PORTP_DR2R_R       	EQU     0x40065500
GPIO_PORTP_DR4R_R       	EQU     0x40065504
GPIO_PORTP_DR8R_R       	EQU     0x40065508
GPIO_PORTP_ODR_R        	EQU     0x4006550C
GPIO_PORTP_PUR_R        	EQU     0x40065510
GPIO_PORTP_PDR_R        	EQU     0x40065514
GPIO_PORTP_SLR_R        	EQU     0x40065518
GPIO_PORTP_DEN_R        	EQU     0x4006551C
GPIO_PORTP_LOCK_R       	EQU     0x40065520
GPIO_PORTP_CR_R         	EQU     0x40065524
GPIO_PORTP_AMSEL_R      	EQU     0x40065528
GPIO_PORTP_PCTL_R       	EQU     0x4006552C
GPIO_PORTP_ADCCTL_R     	EQU     0x40065530
GPIO_PORTP_DMACTL_R     	EQU     0x40065534
GPIO_PORTP_SI_R         	EQU     0x40065538
GPIO_PORTP_DR12R_R      	EQU     0x4006553C
GPIO_PORTP_WAKEPEN_R    	EQU     0x40065540
GPIO_PORTP_WAKELVL_R    	EQU     0x40065544
GPIO_PORTP_WAKESTAT_R   	EQU     0x40065548
GPIO_PORTP_PP_R         	EQU     0x40065FC0
GPIO_PORTP_PC_R         	EQU     0x40065FC4
GPIO_PORTP					EQU 	2_010000000000000
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
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2
caractere_senha				DCB   "*", 0
		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT blinkLEDs
		EXPORT lcd_init
		EXPORT printArrayInLcd
		EXPORT reset_LCD
		EXPORT readKeyboard
		EXPORT GPIOPortJ_Handler
		EXPORT escrever_caractere_senha
		IMPORT SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================

			LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTA                 ;Seta o bit da porta N
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTK
			ORR     R1, #GPIO_PORTL
			ORR     R1, #GPIO_PORTM
			ORR 	R1, #GPIO_PORTP
			ORR 	R1, #GPIO_PORTQ
			STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO

			LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTA                 ;Seta os bits correspondentes �s portas para fazer a compara��o
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
			ORR		R2, #GPIO_PORTK
			ORR 	R1, #GPIO_PORTL
			ORR 	R2, #GPIO_PORTM
			ORR 	R1, #GPIO_PORTP
			ORR 	R2, #GPIO_PORTQ
			TST     R1, R2							;ANDS de R1 com R2
			BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando

		; 2. Limpar o AMSEL para desabilitar a anal�gica
			MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
			LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
			STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
			LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta N
			STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da mem�ria
			LDR		R0, =GPIO_PORTK_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTL_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTM_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTP_AMSEL_R
			STR     R1, [R0]
			LDR		R0, =GPIO_PORTQ_AMSEL_R
			STR     R1, [R0]

		; 3. Limpar PCTL para selecionar o GPIO
			MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			LDR     R0, =GPIO_PORTA_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
			LDR     R0, =GPIO_PORTJ_AHB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta N
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da mem�ria
			LDR     R0, =GPIO_PORTK_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTL_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTM_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTQ_PCTL_R
			STR     R1, [R0]

		; 4. DIR para 0 se for entrada, 1 se for sa�da
			LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta N
			MOV     R1, #2_11110000					;PN1 para LED
			STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PF para n�o transformar entradas em sa�das desnecess�rias
			LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
			MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
			STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria
			LDR     R0, =GPIO_PORTK_DIR_R
			MOV     R1, #2_11111111			
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTL_DIR_R
			MOV     R1, #0x00
			STR     R1, [R0]			
			LDR     R0, =GPIO_PORTM_DIR_R
			MOV     R1, #2_11110111			
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_DIR_R
			MOV     R1, #2_00100000			
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTQ_DIR_R
			MOV     R1, #2_00001111			
			STR     R1, [R0]

		; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
		;    Sem fun��o alternativa
			MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
			LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta N
			STR     R1, [R0]						;Escreve na porta
			LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
			STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTK_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTL_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTM_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTP_AFSEL_R
			STR		R1, [R0]
			LDR     R0, =GPIO_PORTQ_AFSEL_R
			STR		R1, [R0]

		; 6. Setar os bits de DEN para habilitar I/O digital
			LDR     R0, =GPIO_PORTA_AHB_DEN_R			;Carrega o endere�o do DEN
			MOV     R1, #2_11110000                     ;Ativa os pinos PN1 como I/O Digital
			STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 

			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0  como I/O Digital      
			STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			
			LDR     R0, =GPIO_PORTK_DEN_R
			MOV     R1, #2_11111111
			STR 	R1, [R0]
			
			LDR     R0, =GPIO_PORTL_DEN_R
			MOV     R1, #2_00001111
			STR 	R1, [R0]
			
			LDR     R0, =GPIO_PORTM_DEN_R
			MOV     R1, #2_11110111
			STR 	R1, [R0]

			LDR     R0, =GPIO_PORTP_DEN_R
			MOV     R1, #2_00100000
			STR 	R1, [R0]

			LDR     R0, =GPIO_PORTQ_DEN_R
			MOV     R1, #2_00001111
			STR 	R1, [R0]
			
		; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
														;nos bits 0 e 1
			STR     R1, [R0]

			LDR     R0, =GPIO_PORTL_PUR_R				;Carrega o endereço do PUR para a porta L
			MOV     R1, #2_00001111						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]
			
; INTERRUPT SETTINGS

		; Disable interrupt
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #0
			STR R1, [R0]
			
		; Border or level
			LDR R0, =GPIO_PORTJ_AHB_IS_R
			MOV R1, #0
			STR R1, [R0]
			
		; Activate in 1 or 2 borders
			LDR R0, =GPIO_PORTJ_AHB_IBE_R
			MOV R1, #0
			STR R1, [R0]
			
		; Activate in rising or lowering border 0 = lowering, 1 = rising
			LDR R0, =GPIO_PORTJ_AHB_IEV_R
			MOV R1, #2_10
			STR R1, [R0]
			
		; Enable GPIORIS AND GPIOMIS reset
			LDR R0, =GPIO_PORTJ_AHB_ICR_R
			MOV R1, #2_11
			STR R1, [R0]

		; Enable interrupt
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #2_11
			STR R1, [R0]
			
		; Enable interrut in Nvidea
			LDR R0, =NVIC_EN1_R
			MOV R1, #1
			LSL R1, R1, #19
			STR R1, [R0]
			
		; Set port interrupt priority
			LDR R0, =NVIC_PRI12_R
			MOV R1, #5
			LSL R1, R1, #29
			STR R1, [R0]
		
			BX LR


; -------------------------------------------------------------------------------
GPIOPortJ_Handler
		MOV R9, #5

		LDR R0, =GPIO_PORTJ_AHB_ICR_R
		MOV R1, #0x11
		STR R1, [R0]
		BX LR
; -------------------------------------------------------------------------------
; Function to read button input from the matrix keyboard(4x4)
; input: none
; output: R0 -> button pressed
readKeyboard
	; Bounce do teclado
	MOV R0, #300
	PUSH { LR }	
	BL SysTick_Wait1ms
	POP { LR }
	MOV R4, #4
verifica_teclado
	MOV R0, R4
	PUSH { LR }
	BL ler_coluna
	;R0 -> valor da coluna lida
	BL ler_porta_L
	POP { LR }
	CMP R2, #0xF
	BEQ depois_de_verificar_teclado
tecla_pressionada
	LSL R0, R4, #4
	ORR R0, R2
	B depois_de_verificar_teclado
depois_de_verificar_teclado
	CMP R4, #7
	BEQ readKeyboardEnd
	ADD R4, #1
	B verifica_teclado
readKeyboardEnd
	BX LR

; -------------------------------------------------------------------------------
; Função ler_coluna
; Parâmetro de entrada: R0 -> número da coluna que se quer ler - de 4 a 7
; Parâmetro de saída: Não tem
ler_coluna
	LDR R1, =GPIO_PORTM_DIR_R
	LDR R2, [R1] ; Lê para carregar o valor anterior da porta inteira
	
	; R3 vai ter como bit 1 o bit na posição R0
	MOV R3, #1
	LSL R3, R0

	; Seta todas as colunas como entrada
	BIC R2, #0xF0
	; Seta a coluna passada por parâmetro como saída
	ORR R2, R3
	STR R2, [R1] ; Escreve o novo valor da porta
	
	; Escreve 0 na coluna escolhida
	LDR R1, =GPIO_PORTM_DATA_R
	LDR R2, [R1]
	BIC R2, R3 ; Faz o AND negado bit a bit para manter os valores anteriores e limpar somente PM7
	STR R2, [R1]
	
	BX LR

; -------------------------------------------------------------------------------
; Função ler_porta_L - Lê o valor de PL3-PL0
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
ler_porta_L
	LDR R1, =GPIO_PORTL_DATA_R
	LDR R2, [R1] ; 
	AND R2, #0x0F
	
	BX LR

; -------------------------------------------------------------------------------
; Função lcd_enable_and_wait - Dá um enable no LCD, espera por 2ms e dá um disable e espera 2ms
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
lcd_enable_and_wait ;Depois dividir a função em wait 40us e wait 1,64ms
	;EN como 1 para habilitar - EN -> PM2
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	ORR R0, R0, #2_00000100 ; Faz o OR bit a bit para manter os valores anteriores e setar somente o bit
	STR R0, [R1] ; Escreve o novo valor da porta
	
	PUSH { LR }
	MOV R0, #2
	BL SysTick_Wait1ms
	POP { LR }
	
	;EN como 0 para desabilitar - EN -> PM2
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	BIC R0, R0, #2_00000100 ; Faz o AND negado bit a bit para manter os valores anteriores e limpar somente o bit 0
	STR R0, [R1] ; Escreve o novo valor da porta
	
	PUSH { LR }
	MOV R0, #2
	BL SysTick_Wait1ms
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função set_RS_0 - Seta o RS do LCD como 0
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
set_RS_0
	;RS como 0 para enviar instrução - RS -> PM0	
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	BIC R0, R0, #2_00000001 ; Faz o AND negado bit a bit para manter os valores anteriores e limpar somente o bit 0
	STR R0, [R1] ; Escreve o novo valor da porta
	
	BX LR

; -------------------------------------------------------------------------------
; Função set_RS_1 - Seta o RS do LCD como 1
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
set_RS_1
	;RS como 1 para enviar dados - RS -> PM0	
	LDR R1, =GPIO_PORTM_DATA_R ;Carrega-se o endereço
	LDR R0, [R1] ; Lê para carregar o valor anterior da porta inteira
	ORR R0, R0, #2_00000001 ; Faz o OR bit a bit para manter os valores anteriores e setar somente o bit
	STR R0, [R1] ; Escreve o novo valor da porta
	
	BX LR

; -------------------------------------------------------------------------------
; Função envia_instrucao_lcd - Envia um comando para o LCD
; Parâmetro de entrada: R0 -> Comando a ser enviado
; Parâmetro de saída: Não tem 
envia_instrucao_lcd
	LDR R1, =GPIO_PORTK_DATA_R
	STR R0, [R1]
	
	PUSH { LR }
	BL set_RS_0
	POP { LR }
	
	PUSH { LR }
	BL lcd_enable_and_wait
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função envia_dado_lcd - Envia um dado para o LCD
; Parâmetro de entrada: R1 -> Dado a ser enviado
; Parâmetro de saída: Não tem 
envia_dado_lcd
	LDR R0, =GPIO_PORTK_DATA_R
	STR R1, [R0]
	
	PUSH { LR }
	BL set_RS_1
	POP { LR }
	
	PUSH { LR }
	BL lcd_enable_and_wait
	POP { LR }
	
	BX LR

; -------------------------------------------------------------------------------
; Função printArrayInLcd - Escreve uma string no LCD
; Parâmetro de entrada: R0 -> Endereço de memória de início da string
; Parâmetro de saída: Não tem 
printArrayInLcd
escrever_proximo
	PUSH { LR }
	BL reset_LCD
	POP { LR }
	LDRB R1, [R0], #1
	CMP R1, #0
	BEQ printArrayInLcdEnd
	PUSH { LR, R0 }
	BL envia_dado_lcd
	POP { R0, LR }
	B escrever_proximo
printArrayInLcdEnd
	PUSH { LR }
	BL pula_cursor_segunda_linha
	POP { LR }
	BX LR

; -------------------------------------------------------------------------------
; Função reset_LCD - Reseta o LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
reset_LCD
	; Reset LCD
	MOV R0, #0x01
	PUSH { LR, R1 }
	BL envia_instrucao_lcd
	POP { R1, LR }
	BX LR
	
; -------------------------------------------------------------------------------
; Função pula_cursor_segunda_linha - Manda o cursor para a segunda linha do LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
pula_cursor_segunda_linha
	; Reset LCD
	MOV R0, #0xC0
	PUSH { LR, R1 }
	BL envia_instrucao_lcd
	POP { R1, LR }
	BX LR
; -------------------------------------------------------------------------------
; Função Escrever_cofre_travado
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
escrever_caractere_senha
	PUSH { LR }
	LDR R0, =caractere_senha
	BL printArrayInLcd
	POP { LR }
	BX LR
; -------------------------------------------------------------------------------
; Função lcd_init - Inicializa o LCD
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem 
lcd_init
	; Reset no LCD -----------------------------------------------
	PUSH { LR }
	BL reset_LCD
	POP { LR }
	
	; Inicializa configuração do LCD -----------------------------------------------
	MOV R0, #0x38
	PUSH { LR }
	BL envia_instrucao_lcd
	POP { LR }
	
	; Inicializa configuração do LCD -----------------------------------------------
	MOV R0, #0xF
	PUSH { LR }
	BL envia_instrucao_lcd
	POP { LR }

	BX LR


; -------------------------------------------------------------------------------
; Função Pisca_LED
; Parâmetro de entrada: R5 --> Liga ou Desliga LEDs
; Parâmetro de saída: Não tem
blinkLEDs
	CMP R5,#-1
	BEQ apaga_Leds
liga_LEDs
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =2_11110000
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =2_00001111
	STR R2, [R1]
	B ativa_Transistor
apaga_Leds
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR	R2, =2_00000000
	STR R2, [R1]
	LDR	R1, =GPIO_PORTQ_DATA_R		    	;Carrega o valor do offset do data register
	LDR	R2, =2_00000000
	STR R2, [R1]
	B ativa_Transistor	

ativa_Transistor
	LDR	R3, =GPIO_PORTP_DATA_R
	MOV R4, #2_00100000
	STR R4, [R3]
	
	MOV R0, #3
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	MOV R2, #2_00000000
	LDR	R3, =GPIO_PORTP_DATA_R
	STR R2, [R3]
	
	MOV R0, #3
	PUSH { LR }
	BL SysTick_Wait1ms
	POP { LR }
	
	BX LR									;Retorno

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo