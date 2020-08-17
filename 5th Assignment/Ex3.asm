include 'macros.inc'
				.8086
				.MODEL SMALL
				.STACK 256  

DATA SEGMENT
				SPACE DB " $"
				X_EQ DB "x=$" 
				Y_EQ DB "y=$" 
				SUM_MSG DB "x+y=$"
				SUB_MSG DB "x-y=$"
				SUB_MSG_2 DB "x-y=-$"
				NUM1 DB ?
				NUM2 DB ?
				SUM DW ?
DATA ENDS

CODE SEGMENT
MAIN PROC FAR
				MOV AX,@DATA
				MOV DS,AX 
START:			CALL HEX_KEYB 
				ROL AL,4						; move the digit in the first 4 MSB position (xxxx0000)
				MOV BL,AL						; save it to BL
				CALL HEX_KEYB					; read second digit
				ADD BL,AL						; add the second digit to the saved number (xxxx0000)+(0000xxxx) = (xxxxxxxx)
				MOV NUM1,BL						; NUM1 has the first number
				CALL HEX_KEYB
				ROL AL,4						; move the digit in the first 4 MSB position (xxxx0000)
				MOV BL,AL						; save it to BL
				CALL HEX_KEYB					; read second digit
				ADD BL,AL						; add the second digit to the saved number (xxxx0000)+(0000xxxx) = (xxxxxxxx)
				MOV NUM2,BL						; NUM2 has the first number
				NEW_LINE
				PRINT_STRING X_EQ
				MOV BL,NUM1						; move NUM1 to BL in order to print it
				CALL PRINT_HEX					; call print_hex to print the number
				PRINT_STRING SPACE
				PRINT_STRING Y_EQ
				MOV BL,NUM2						; move NUM2 to BL in order to print it
				CALL PRINT_HEX					; call print_hex to print the number
				NEW_LINE
				PRINT_STRING SUM_MSG
				MOV BH,0						; BX will be equal BH = 0 
				MOV BL,NUM1						; and BL = NUM1
				MOV SUM,BX						; move BX to SUM
				MOV BH,0						; BX will be equal to BH =0
				MOV BL,NUM2						; and BL = NUM2
				ADD SUM,BX						; SUM += BX
				MOV BX,SUM						; Move SUM to BX in order to print the result
				CALL PRINT_DEC					; call print_dec to print the result in DEC form
				PRINT_STRING SPACE
				MOV BH,0						; BX will be equal to BH = 0
				MOV BL,NUM2						; and BL = NUM2
				CMP NUM1,BL						; if num1 >= BL then 
				JAE POSITIVE					; jump positive
				PRINT_STRING SUB_MSG_2
				MOV BL,NUM2 					; else move num2 to bl
				SUB BL,NUM1						; and subract num1 from bl
				CALL PRINT_DEC					; call print_dec to print result in DEC form
				NEW_LINE
				JMP START
POSITIVE:		PRINT_STRING SUB_MSG 			; if num1 is greater than num2
				MOV BL,NUM1						;  move num1 to bl and subtract
				SUB BL,NUM2						; num2 from num1
				CALL PRINT_DEC					; call print_dec to print result in DEC form
				NEW_LINE
				JMP START
MAIN ENDP

HEX_KEYB PROC NEAR
				PUSH DX							; saving DX because READ macro uses DL
INVALID:		READ
				CMP AL, 46H						; if ASCII > 46 invalid input
				JG INVALID						; jump invalid
				CMP AL, 40H						; else if ASCII > 40 then 
				JG FINISH_LETTER				; and jump to FINISH_LETTER
				CMP AL, 39H						; if ASCII < 30 invalid input
				JG INVALID						; jump invalid
				CMP AL, 29H						; if ASCII > 39 invalid input
				JG FINISH_NUMB					; jump FINISH_NUMB else
				JMP INVALID						; jump invalid
FINISH_LETTER:	SUB AL, 37H						; subtract 37H (i.e 41H-37H = 0AH)
				POP DX							; bring back DX
				RET								; return
FINISH_NUMB:	SUB AL, 30H						; subtract 30H (i.e 39H-30H = 09H)
				POP DX
				RET
HEX_KEYB ENDP

PRINT_DEC PROC NEAR
				MOV AH,0
				MOV AX,BX						; moving BX to AX
				MOV BL,10						; use for division with 10
				MOV CX,0						; digits counter starting from zero
DEC_LOOP:		DIV BL							; divide number with 10
				CMP AX,00H						; if AL is zero we converted the number
				JE CALL PRINT_DIG				; so we jump to PRINT_DIG to print the number
				PUSH AX							; save remainder
				INC CX							; else increase number of digits
				MOV AH,00H
				JMP DEC_LOOP
				RET
PRINT_DEC ENDP

PRINT_HEX PROC NEAR
				MOV AH,0
				MOV AL,BL						; AH = 0 
				MOV BL,16						; AL = BL so AX = 00000000(BL)
				MOV CX,1						; BL = 16
HEX_LOOP:		DIV BL							; digits counter
				PUSH AX							; Divide with 16 
				CMP AL,00H						; save remainder
				JE CALL PRINT_DIG				; if AL is zero we converted the number
				INC CX							; and call print digit
				MOV AH,00H						; else increase digits counter
				JMP HEX_LOOP					; make AH = 0
				RET								; keep looping
PRINT_HEX ENDP

PRINT_DIG PROC NEAR
				CMP CX,0						; in case of CX is not zero then 
				JNE PRINT_LOOP					; CX and stack have the right data
				INC CX							; else means that x-y or x+y equals zero
				MOV AX,0						; so we need to increase CX and add to stack
				PUSH AX							; zero before we start the printing proccess
PRINT_LOOP:		POP DX							; pop digit to print it
				MOV DL,DH						; move DH to DL and
				MOV DH,00H						; make DH zero so as DX has the digit
				CMP DX,09H						; if it's greater than 9 then it's a letter
				JG LETTER						; go to letter
				ADD DX,30H						; else add 30 for ascii convertion
				JMP CONT						; and jump to cont label
LETTER:			ADD DX,37H						; if its a letter then add 37h for ascii convertion
CONT:			MOV AH,02H						; to print digit on screen
				INT 21H							; interupt for print
				LOOP PRINT_LOOP					; loop until the whole number is printed
				RET
PRINT_DIG ENDP