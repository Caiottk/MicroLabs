; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Defini��es de Valores

VECT_SIZE EQU 8
; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		
offset SPACE 0x400
vect SPACE VECT_SIZE
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT LightUp7SegLeft
		IMPORT LightUp7SegRight
		IMPORT LightUpLEDs	
		IMPORT GetPushBtnsState	


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	MOV R3, #0
	
atualizaBaseAtual
; ****************************************
;Fun��o que itera a base atual
; ****************************************
	LDR R2, =0x3FE
    LDR R4, [R2]
	
    ANDS R4, R4, #7  ; R2 = i mod 8
    ADDS R4, R4, #1  ; R2 = (i mod 8) + 1
	
    STR R4, [R2]
	
    LDR R5, =vect   ; Carrega o conte�do de Vect[i] em R5
    ADD R5, R5, R4  ; 
    LDR R5, [R5]
	
	
	
	BX LR

;--------------------------------------------------------------------------------
atualizaFatorMultiplicativo
; ****************************************
;Fun��o que itera o fator multiplicativo
; ****************************************
	LDR R5, =0x3FE   ; Carrega i
	LDR R5, [R5]
	
	LDR R2, =vect   ; Carrega o conte�do de Vect[i]
	ADD R2, R2, R5
	LDRB R4, [R2]
	
	ADD R4, R4, #1	; Atualiza o conte�do de Vect[i] para (Vect[i] +1) mod 10
	CMP R4, #10
	IT GE
		SUBGE R4, R4, #10
	
	STR R4, [R2]
	
    
	
	BX LR
;--------------------------------------------------------------------------------
MainLoop
; ****************************************
; ****************************************
	
	
	
	BL GetPushBtnsState
	MOV R1, R0
	MOV R2, #500
	CMP R0, #2_10
	ITT EQ
		BLEQ espera_500ms
		BLEQ atualizaBaseAtual
;	ITT	EQ
;		MOVEQ R0, R3
;		BLEQ LightUpLEDs
	CMP R1, #2_01
	ITT EQ
		BLEQ espera_500ms
		BLEQ atualizaFatorMultiplicativo
	
	ADD R3, R3, #1
	CMP R3, #10
	IT EQ
		MOVEQ R3, #0
	
	B MainLoop

;--------------------------------------------------------------------------------
espera_500ms
; ****************************************
;Fun��o que cria um atraso de 0,5s entre o aperto du pushButton e seu tratamento
; ****************************************

	BL Systick_Wait1ms
    SUBS R2, R2, #1
    CMP R2, #0
    BNE espera_500ms
	BX LR
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
