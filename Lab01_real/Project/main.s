; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores

VECT_SIZE EQU 8
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		
offset SPACE 0x400
vect SPACE VECT_SIZE
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT LightUp7SegLeft
		IMPORT LightUp7SegRight
		IMPORT LightUpLEDs	
		IMPORT GetPushBtnsState	


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	MOV R3, #0
	
atualizaBaseAtual
; ****************************************
;Função que itera a base atual
; ****************************************
	LDR R2, =0x3FE
    LDR R4, [R2]
	
    ANDS R4, R4, #7  ; R2 = i mod 8
    ADDS R4, R4, #1  ; R2 = (i mod 8) + 1
	
    STR R4, [R2]
	
    LDR R5, =vect   ; Carrega o conteúdo de Vect[i] em R5
    ADD R5, R5, R4  ; 
    LDR R5, [R5]
	
	
	
	BX LR

;--------------------------------------------------------------------------------
atualizaFatorMultiplicativo
; ****************************************
;Função que itera o fator multiplicativo
; ****************************************
	LDR R5, =0x3FE   ; Carrega i
	LDR R5, [R5]
	
	LDR R2, =vect   ; Carrega o conteúdo de Vect[i]
	ADD R2, R2, R5
	LDRB R4, [R2]
	
	ADD R4, R4, #1	; Atualiza o conteúdo de Vect[i] para (Vect[i] +1) mod 10
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
;Função que cria um atraso de 0,5s entre o aperto du pushButton e seu tratamento
; ****************************************

	BL Systick_Wait1ms
    SUBS R2, R2, #1
    CMP R2, #0
    BNE espera_500ms
	BX LR
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
