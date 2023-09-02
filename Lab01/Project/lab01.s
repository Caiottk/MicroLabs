; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
INITIAL_MEM_POS   EQU 0x20000400
HIGHEST_INCID_POS EQU 0x20000500
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
incidencias SPACE 26										   

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

; -------------------------------------------------------------------------------
; Fun��o main()
Start  
; Comece o c�digo aqui <======================================================
	
STRING1 DCB "MACACOCOMGIRAFA", 0
	LDR R0, =incidencias
	LDR R1, =STRING1
	
ReadString
	LDRB R2, [R1], #1 	;R2 gets value from the string letter
	CMP R2, #0x5A		
	ITE HI				;Decides where in the incidencias vector the value will be iterated
		SUBHI R3, R2, #0x61
		SUBLS R3, R2, #0x41
		
	ADD R0, R0, R3
	LDRB R4, [R0]
	ADD R4, R4, #1
	STRB R4, [R0]
	LDR R0, =incidencias
	
	LDRB R2, [R1]
	CMP R2, #0
	BNE ReadString
	
	MOV R9, #0
    MOV R5, #26

loop
    LDRB R6, [R0]

    CMP R6, R9

    BGT update_max

    ADDS R0, R0, #1

    SUBS R5, R5, #1

	CMP R5, #0
	BEQ done
	B loop

update_max
    MOV R9, R6

    ADDS R0, R0, #1
    SUBS R5, R5, #1
	CMP R5, #0
    BEQ done
	B loop

done
	NOP

		

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
