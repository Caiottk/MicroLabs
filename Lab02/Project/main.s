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
sysState    SPACE 0x1
masterPword SPACE 0x4
currPword   SPACE 0x4
guessPword  SPACE 0x4
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
	LDR R1, =sysState
	LDR R1, [R1]
	
	CMP R1, #0
	IT EQ
	BLEQ waitNewPword
	
	CMP R1, #1
	IT EQ
	BLEQ closedSafe
	
	CMP R1, #2
	IT EQ
	BLEQ waitJ0Interrup
	
	CMP R1, #1
	IT EQ
	BLEQ waitMasterPword
	
	B MainLoop
	
;--------------------------------------------------------------------------------
; Routine for entering a new password and close the safe
waitNewPword

	BX LR
;--------------------------------------------------------------------------------
; Routine for when the safe is closed: either opens or locks permanently
closedSafe

	BX LR
;--------------------------------------------------------------------------------
; Routine that waits for a interruption and disables all other funcions
waitJ0Interrup

	BX LR
;--------------------------------------------------------------------------------
; Routine to check if the master password was correctly written
waitMasterPword

	BX LR
;--------------------------------------------------------------------------------
; Initializes the first array pos and the multiplicator factor with 1, as requested
InitilizeVars
	LDR R1, =masterPword
	MOV R2, #0x0304
	MOVT R2, #0x0102
	STR R2, [R1]
	
	BX LR
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
