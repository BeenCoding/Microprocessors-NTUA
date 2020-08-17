				include 'macros.inc'
				.8086
				.MODEL SMALL
				.STACK 256

DATA SEGMENT
				SAVE_DX DW ?
				MSG DB "START(Y,N):$"
				ERR DB "ERROR$"
DATA ENDS

CODE SEGMENT
MAIN PROC FAR
				MOV AX,@DATA
				MOV DS,AX
START:			PRINT_STRING MSG
				NEW_LINE
WAIT_INPUT:		READ
				CMP AL,59H						; check if input i Y
				JE YES							; if so continue
				CMP AL,4EH						; else if input in N
				JE NO							; stop the program
				JMP WAIT_INPUT					; wait until valid input
NO:				NEW_LINE
				EXIT
YES:			NEW_LINE
				CALL GET_INPUT					; read input
				NEW_LINE
				CMP BX,4095						; if input is 4095 
				JE ERROR						; then T is over 999,9 so error
				MOV AX,BX
				MOV BX,2000						; find the corresponding Voltage by input*2/4095 
				MUL BX							; we multiply by 2000 instead of 2 for more accuracy
				MOV BX,4095
				DIV BX
				CMP AX,1000						; under 1V go to first region in graph
				JBE REGION1
				CMP AX,1800						; under 1,8V go to second region in graph
				JBE REGION2
				JMP REGION3						; else it's in region 3
ERROR:			PRINT_STRING ERR				; error message
				NEW_LINE
				JMP START
REGION1:		MOV BX,500						; T=500V
				MUL BX
				MOV BX,1000						; divide by 1000 to fix result
				DIV BX
				JMP PRINT_ME
REGION2:		MOV BX,250						; T=250V + 250
				MUL BX
				MOV BX,1000						; divide by 1000 to fix result
				DIV BX
				ADD AX,250
				JMP PRINT_ME
REGION3:		MOV BX,1500						; T=1500V - 2000
				MUL BX
				MOV BX,1000						; divide by 1000 to fix result
				DIV BX
				SUB AX,2000
				JMP PRINT_ME
PRINT_ME:		MOV SAVE_DX,DX
				CALL PRINT_DEC
				PRINT "."
				MOV AX,SAVE_DX
				CALL PRINT_DEC
				NEW_LINE
				JMP START						; infinite run of program
MAIN ENDP

; Procedure to get input. After getting first without error, places it in BH
; moves to the second digit. After getting second without error, places it in 
; four MSB'S of BL. Then gets the third. After getting the third without error
; places it in the last four MSB'S of BL. So the 3 digit HEX is in BX with form
; 0000FFFFSSSSTTTT , where F is first, S is second , T is third.
GET_INPUT PROC NEAR
				MOV BX,0
FIRST:			READ
				CMP AL,4EH
				JE STOP
				CMP AL,30H
				JL FIRST
				CMP AL,39H
				JBE NUMA
				CMP AL,40H
				JG LETTERA
				CMP AL,46H
				JG FIRST
NUMA:			SUB AL,30H
				MOV BH,AL
				JMP SECOND
LETTERA:		SUB AL,37H
				MOV BH,AL
				JMP SECOND
SECOND:			READ
				CMP AL,4EH
				JE STOP
				CMP AL,30H
				JL SECOND
				CMP AL,39H
				JBE NUMB
				CMP AL,40H
				JG LETTERB
				CMP AL,46H
				JG SECOND
NUMB:			SUB AL,30H
				ROL AL,4
				MOV BL,AL
				JMP THIRD
LETTERB:		SUB AL,37H
				ROL AL,4
				MOV BL,AL
				JMP THIRD
THIRD:			READ
				CMP AL,4EH
				JE STOP
				CMP AL,30H
				JL THIRD
				CMP AL,39H
				JBE NUMC
				CMP AL,40H
				JG LETTERC
				CMP AL,46H
				JG THIRD
NUMC:			SUB AL,30H
				ADD BL,AL
				RET
LETTERC:		SUB AL,37H
				ADD BL,AL
				RET
STOP:			EXIT
GET_INPUT ENDP

PRINT_DEC PROC NEAR
				MOV BH,0
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

CODE ENDS