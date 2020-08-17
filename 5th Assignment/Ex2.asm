include 'macros.inc'
			.8086
			.MODEL SMALL
			.STACK 300 
DATA SEGMENT
			TABLE DB 256 DUP(?)
			MIN DB ?
			MAX DB ?
DATA ENDS

CODE SEGMENT
MAIN PROC FAR
			MOV AX,@DATA
			MOV DS,AX 
			MOV AL,254				; load the first number of the table (254)
			MOV DI,0				; table index
STORE:		MOV [TABLE + DI],AL		; load number in table
			DEC AL					; decrease number
			INC DI					; increase index
			CMP AL,254				; while number is not equal to 254
			JNE STORE				; keep looping

			MOV DI,0				; start DI again from zero
			MOV AH,0				; make AH = 0 to avoid errors

ADDING:		MOV AL,[TABLE+DI]		; AL = [TABLE+DI]
			ADD DX,AX				; DX += AX
			ADD DI,2				; DI += 2 so as we get only the even numbers
			CMP AL,0				; while AL not equal to 0
			JNE ADDING				; keep looping

			MOV AX,DX				; move the result of summation to AX
			MOV BH,0				; Get BX ready( we want BX to be equal to 127)
			MOV BL,127				; so BH = 0 and BL = 127
			DIV BL					; Divide AL to BL

			MOV AH,0				; make AH = 0 to avoid errors
			CALL PRINT_HEX			; print the average
			NEW_LINE				; change line

			MOV MIN,255				; set min as 255(biggest value in table)
			MOV MAX,0				; set max as 0(smallest value in table)
			MOV DI,65535			; set index as FFFFH(max value) so when increased becomes zero for first loop
MIN_MAX:	INC DI					; increase index
			CMP DI,256				; when it reaches 256
			JE FINISH				; jump to finish
FIRST_TIME:	MOV AL,[TABLE + DI]		; load number from table
			CMP MIN,AL				; compare number with MIN and if it is bigger 
			JNA SKIP				; skip the next line
			MOV MIN,AL				; set the MIN equal to the current number

SKIP:		CMP MAX,AL				; compare number with MAX and if it is smaller
			JA MIN_MAX				; loop
			MOV MAX,AL				; else set the MAX equal to the current number
			JMP MIN_MAX				; loop

FINISH:		MOV AH,0				; make AH = 0 to avoid errors
			MOV AL,MIN				; set AL as the MIN in order to print it
			CALL PRINT_HEX			; print MIN
			NEW_LINE				; change line
			MOV AH,0				; make AH = 0 to avoid errors
			MOV AL,MAX				; set AL as the MAX in order to print it
			CALL PRINT_HEX			; print MAX

			EXIT
MAIN ENDP


PRINT_HEX PROC NEAR
				MOV AH,0			; make AH = 0 to avoid errors
				MOV BL,16			; set B as 16 in order to divide
				MOV CX,1			; digits counter
HEX_LOOP:		DIV BL				; divide the number with 16
				PUSH AX				; save the digit in stack
				CMP AL,00H			; if number reaches 0 
				JE CALL PRINT_DIG	; then start printing
				INC CX				; else inc digit counter
				MOV AH,00H			; make AH = 0 to avoid errors
				JMP HEX_LOOP		; loop
				RET
PRINT_HEX ENDP

PRINT_DIG PROC NEAR
PRINT_LOOP:		POP DX				; pop digit to print it
				MOV DL,DH			; move DH to DL and
				MOV DH,00H			; make DH zero so as DX has the digit
				CMP DX,09H			; if it's greater than 9 then it's a letter
				JG LETTER			; go to letter
				ADD DX,30H			; else add 30 for ascii convertion
				JMP CONT			; and jump to cont label
LETTER:			ADD DX,37H			; if its a letter then add 37h for ascii convertion
CONT:			MOV AH,02H			; to print digit on screen
				INT 21H				; interupt for print
				LOOP PRINT_LOOP		; loop until the whole number is printed
				RET
PRINT_DIG ENDP
CODE ENDS
