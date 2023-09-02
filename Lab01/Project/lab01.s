; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
INITIAL_MEM_POS   EQU 0x20000400
HIGHEST_INCID_POS EQU 0x20000500
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
incidencias SPACE 26										   

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

; -------------------------------------------------------------------------------
; Função main()
Start  
; Comece o código aqui <======================================================
	
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

		

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
