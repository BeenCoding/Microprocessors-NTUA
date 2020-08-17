				include 'macros.inc'
				.8086
				.MODEL SMALL
				.STACK 256

DATA SEGMENT
				TABLE_LETTERS DB 16 DUP(?)
				TABLE_NUMBERS DB 16 DUP(?)
				TABLE DB 16 (?)

DATA ENDS

CODE SEGMENT

MAIN PROC FAR
				MOV AX,@DATA
				MOV DS,AX
				JMP BEGIN
START:			NEW_LINE
BEGIN:			MOV CL,0							; total counter
				MOV DX,0							; initialize letters counter
				MOV BX,0							; initialize numbers counter

READ_LOOP:		READ
				CMP AL,0DH							; equal to enter
				JE QUIT
				CMP AL, 30H
				JL READ_LOOP						; if less than 0 not valid
				CMP AL, 39H
				JNA VALID_N							; if given less or equal to 9 is valid
				CMP AL, 41H
				JL READ_LOOP						; if less than ascii of A is not valid
				CMP AL, 5AH
				JNA VALID_L							; if less or equal to ascii code of Z valid
				JMP READ_LOOP						; else invalid

VALID_N:		MOV DI,BX							; move BX to DI
				MOV [TABLE_NUMBERS + DI],AL			; move valid number to numbers table
				MOV CH,0
				MOV DI,CX
				MOV [TABLE + DI],AL					; place number to merged table too
				INC BX								; increase numbers counter
				INC CL								; increase total counter
				CMP CL,16							; if reached 16 all input is given
				JE COMPLETED						; so move to completed tag
				JMP READ_LOOP						; else jump to read_loop

VALID_L:		MOV DI,DX							; move DX to DI
				MOV [TABLE_LETTERS + DI],AL			; move valid letter to letters table
				MOV CH,0
				MOV DI,CX
				MOV [TABLE + DI],AL					; place letter to merged table too
				INC DX								; increase letters counter
				INC CL								; increase total counter
				CMP CL,16							; if reached 16 all input is given
				JE COMPLETED						; so move to completed tag
				JMP READ_LOOP						; else jump to read_loop

COMPLETED:		NEW_LINE
				MOV DI,0							; DI will be the index for printing
PRINT_MATRIX:	MOV AL,[TABLE + DI]					; move the table element in AL to print it
				PRINT AL							; print the element
				INC DI								; increase index
				CMP DI, 16							; when it reaches 16 
				JE PRINT_SORTED						; go to sorted
				JMP PRINT_MATRIX					; else loop

PRINT_SORTED:	NEW_LINE
				MOV DI,BX							; BX holds the number of numbers
				CMP DI,0							; if numbers are zero
				JE L2								; go to print letters
				MOV DI,0							; DI will be the index for printing numbers
L1:				MOV AL,[TABLE_NUMBERS + DI]			; move the table_number element in AL to print it
				PRINT AL							; print the element
				INC DI								; increase index
				CMP DI,BX							; when it reaches the number of numbers
				JAE L2N								; go to print letters
				JMP L1								; else loop

L2N:			MOV DI,DX							; DX holds the number of letters
				CMP DI,0							; if numbers are zero
				JE START							; restart program
				PRINT '-'							; '-' between numbers and letters
L2:				MOV DI,0							; DI will be the index for printing letters
CONT_L2N:		MOV AL,[TABLE_LETTERS + DI]			; move the table_letter element in AL to print it
				ADD AL,32
				PRINT AL							; print the element
				INC DI								; increase index
				CMP DI,DX							; when it reaches the number of letters
				JE START							; restart program
				JMP CONT_L2N						; else loop

QUIT:			EXIT
MAIN ENDP
CODE ENDS