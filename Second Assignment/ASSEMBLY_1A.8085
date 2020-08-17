ARXH:	IN 10H
	MVI A,FFH  	; FFH=255 decimal
	LXI D,0900H 	; DE pair has memory location 0900H
	MVI H,00H 	; H is a counter
LOOPA: STAX D 		; store accumulator to register pair DE
	DCR A 		; A--;
	INX D 		; Move one memory space down
	CPI 00H 
	JNZ LOOPA
	LXI D,0900H	; DE pair has memory location 0900H
PRINT: LDAX D 		; load contents of DE mem loc to A
	LXI B,0BB8H   	; 3 sec delay
	CALL DELB     	; to see result
	CMA 
	STA 3000H 	; print result to LEDs
	INX D 		; Move one memory space down
	INR H 		; H++
	MOV A,H
	CPI 00H 	;compare H to 0 (256)
	JNZ PRINT 	;IF H>0 PRINT next 
END
