include 'macros.inc'

CODE SEGMENT
MAIN PROC FAR
START:			CALL HEX_KEYB		; read first digit
				ROL AL,4			; move the digit in the first 4 MSB position (xxxx0000)
				MOV BL,AL			; save it to BL
				CALL HEX_KEYB		; read second digit
				ADD BL,AL			; add the second digit to the saved number (xxxx0000)+(0000xxxx) = (xxxxxxxx)
				PUSH BX				; save the completed number in stack
				PRINT '='
				CALL PRINT_DEC		; convert to decimal and print it 
				POP BX				; pop the saved number for the next convertion
				PUSH BX				; save it again for the next convertion
				PRINT '='
				CALL PRINT_OCT		; convert to octadecimal and print it 
				POP BX				; pop the saved number for the next convertion
				PRINT '='
				CALL PRINT_BIN		; convert hex to binary
				NEW_LINE
				JMP START			; inf loop
MAIN ENDP

; a function that reads input digit
; accepts only 0...9 and A...F and Q for terminating
HEX_KEYB PROC NEAR
				PUSH DX				; saving DX because READ macro uses DL
INVALID:		READ
				CMP AL, 'Q'			; if Q then terminate
				JE CALL QUIT		; jump to QUIT
				CMP AL, 46H			; if ASCII > 46 invalid input
				JG INVALID			; jump invalid
				CMP AL, 40H			; else if ASCII > 40 then 
				JG FINISH_LETTER	; and jump to FINISH_LETTER
				CMP AL, 39H			; if ASCII < 30 invalid input
				JG INVALID			; jump invalid
				CMP AL, 29H			; if ASCII > 39 invalid input
				JG FINISH_NUMB		; jump FINISH_NUMB else
				JMP INVALID			; jump invalid
FINISH_LETTER:	SUB AL, 37H			; subtract 37H (i.e 41H-37H = 0AH)
				POP DX				; bring back DX
				RET					; return
FINISH_NUMB:	SUB AL, 30H			; subtract 30H (i.e 39H-30H = 09H)
				POP DX
				RET
HEX_KEYB ENDP

QUIT PROC NEAR
				EXIT 
QUIT ENDP

; This function converts hex to dec
PRINT_DEC PROC NEAR
				MOV AH,0			; make AH zero so as the number is AX = 00000000xxxxxxxx(only BL)
				MOV AL,BL			; moving BL to AL
				MOV BL,10			; use for division with 10
				MOV CX,1			; digits counter
DEC_LOOP:		DIV BL				; divide number with 10
				PUSH AX				; save remainder
				CMP AL,00H			; if AL is zero we converted the number
				JE CALL PRINT_DIG	; so we jump to PRINT_DIG to print the number
				INC CX				; else increase number of digits
				MOV AH,00H			; make AH zero for same reason with line 27
				JMP DEC_LOOP
				RET
PRINT_DEC ENDP

PRINT_OCT PROC NEAR
				MOV AH,0			; make AH zero so as the number is AX = 00000000xxxxxxxx(only BL)
				MOV AL,BL			; moving BL to AL
				MOV BL,8			; use for division with 8
				MOV CX,1			; digits counter
OCT_LOOP:		DIV BL				; divide number with 8
				PUSH AX				; save remainder
				CMP AL,00H			; if AL is zero we converted the number
				JE CALL PRINT_DIG	; so we jump to PRINT_DIG to print the number
				INC CX				; else increase number of digits
				MOV AH,00H			; make AH zero for same reason with line 51
				JMP OCT_LOOP
				RET
PRINT_OCT ENDP

PRINT_BIN PROC NEAR
				MOV AH,0			; make AH zero so as the number is AX = 00000000xxxxxxxx(only BL)
				MOV AL,BL			; moving BL to AL
				MOV BL,2			; use for division with 2
				MOV CX,1			; digits counter
BIN_LOOP:		DIV BL				; divide number with 2
				PUSH AX				; save remainder
				CMP AL,00H			; if AL is zero we converted the number
				JE CALL PRINT_DIG	; so we jump to PRINT_DIG to print the number
				INC CX				; else increase number of digits  
				MOV AH,00H			; make AH zero for same reason with line 72
				JMP BIN_LOOP
				RET
PRINT_BIN ENDP

PRINT_DIG PROC NEAR
PRINT_LOOP:		POP DX				; pop digit to be printed
				MOV DL,DH			; move DH to DL and
				MOV DH,00H			; make DH zero so as DX has the digit
				ADD DX,30H			; ASCII convertion
				MOV AH,02H			; to print digit on screen
				INT 21H				; interupt for print
				LOOP PRINT_LOOP		; loop until the whole number is printed
				RET
PRINT_DIG ENDP
CODE ENDS