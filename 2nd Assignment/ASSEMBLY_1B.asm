ARXH:		IN 10H
		MVI A,FFH	; FFH=255 decimal
		LXI B,0900H	; BC pair has memory location 0900H
		LXI D,0000H	; INIT DE PAIR  
		MVI L,00H	;L IS A COUNTER
			
LOOPA:  	STAX B		;store accumulator to register pair HL
		DCR A		; A--;
		INX B		;Move one memory space down
		CPI 00H 
		JNZ LOOPA
		;FINISHED INIT MATRIX STARTIN IN 0900H
			
		LXI B,0900H	; HL pair has memory location 0900H
DATA:		LDAX B		;load contents of HL mem loc to A
		MVI H,08H	; H=8;
CNTZEROS:  	RAL		; MOVE MSB TO Carry in order to check it.
		JC NEXTBIT 
		INX D
NEXTBIT:	DCR H		; H--;
		STA 08FFH	; store A in memory loc x08ff
		MOV A,H 
		CPI 00H 
		LDA 08FFH	; Load A 
		JNZ CNTZEROS
			
		INX B		;Move one memory space down
		INR L		; L++ 
		MOV A,L 
		CPI 00H		;compare L to 0 (256)
		JNZ DATA 	
			
END

