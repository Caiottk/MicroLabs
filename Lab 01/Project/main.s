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
offset    SPACE 0x400
vect 	  SPACE VECT_SIZE
vectItr   SPACE 0x1
onesInNum SPACE 0x1
tensInNum SPACE 0x1
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
		IMPORT DisableAllLEDs


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL InitilizeVars
;--------------------------------------------------------------------------------
MainLoop
	
	BL GetPushBtnsState
	MOV R1, R0
	CMP R0, #2_01
	IT EQ
		BLEQ atualizaBaseAtual
	CMP R1, #2_10
	IT EQ
		BLEQ atualizaFatorMultiplicativo
		
	LDR R1, =vectItr	; Lights up the LED's with the given numbers
	LDR R2, =tensInNum
	LDR R3, =onesInNum
	LDRB R0, [R1]
	BL LightUpLEDs
	MOV R0, #1
	BL SysTick_Wait1ms
	LDRB R0, [R2]
	BL LightUp7SegLeft
	MOV R0, #1
	BL SysTick_Wait1ms
	LDRB R0, [R3]
	BL LightUp7SegRight
	MOV R0, #1
	BL SysTick_Wait1ms
	BL DisableAllLEDs
	
	B MainLoop
	
; ****************************************
;Função que itera a base atual
; ****************************************
atualizaBaseAtual
	PUSH{LR}
	BL espera_200ms
	POP{LR}
	LDR R2, =vectItr
    LDRB R4, [R2]
	
    AND R4, R4, #7  ; R2 = i mod 8
    ADDS R4, R4, #1  ; R2 = (i mod 8) + 1
	
    STRB R4, [R2]
	
	PUSH{LR}
	BL multiplyBases
	POP{LR}
	
	BX LR

;--------------------------------------------------------------------------------
; ****************************************
;Função que itera o fator multiplicativo
; ****************************************
atualizaFatorMultiplicativo
	PUSH{LR}
	BL espera_200ms
	POP{LR}

	LDR R5, =vectItr   ; Carrega i
	LDRB R5, [R5]
	SUB R5, R5, #1
	
	LDR R2, =vect   ; Carrega o conteúdo de Vect[i]
	ADD R2, R2, R5
	LDRB R4, [R2]
	
	ADD R4, R4, #1	; Atualiza o conteúdo de Vect[i] para (Vect[i] +1) mod 10
	CMP R4, #10
	IT GE
		MOVGE R4, #0
	
	STRB R4, [R2]
	
	PUSH{LR}
	BL multiplyBases
	POP{LR}
	
	BX LR

;--------------------------------------------------------------------------------
; Multiplies the bases and stores the decimal places in the correct mem position
multiplyBases
	LDR R5, =vectItr   ; Carrega i
	LDRB R5, [R5]
	SUB R6, R5, #1
	
	LDR R2, =vect   ; Carrega o conteúdo de Vect[i]
	ADD R2, R2, R6
	LDRB R4, [R2]
	
	MUL R6, R4, R5
	
	MOV R5, #10		; Puts the division result in R4
	UDIV R4, R6, R5
	
	MUL R7, R4, R5  ; Puts remainder in R5
	SUB R5, R6, R7
	
	LDR R2, =tensInNum ; Saves them in the correct places
	STRB R4, [R2]
	LDR R2, =onesInNum
	STRB R5, [R2]
	
	BX LR

;--------------------------------------------------------------------------------
espera_200ms
; ****************************************
;Função que cria um atraso de 0,5s entre o aperto du pushButton e seu tratamento
; ****************************************
	MOV R0, #200
	PUSH {LR}
	BL SysTick_Wait1ms
    POP {LR}
	
	BX LR
	
;--------------------------------------------------------------------------------
; Initializes the first array pos and the multiplicator factor with 1, as requested
InitilizeVars
	LDR R1, =vect
	MOV R2, #1
	STRB R2, [R1]
	LDR R1, =vectItr
	STRB R2, [R1]
	
	PUSH{LR}
	BL multiplyBases
	POP{LR}
	
	BX LR
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
