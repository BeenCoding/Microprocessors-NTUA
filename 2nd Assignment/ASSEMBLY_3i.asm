; The idea of this program is to find out the position of the first one.
; We start the counter from 8 and decreasing every time until the position
; is found. When found, we jump to FOUND label where we do exactly
; B RALS. I.E if B is equal to 0 then 0 RALS are done, if B is 7, 7 RALS
; are done. Each time a RAL is done then we decrease B by one and continue
; until B reaches zero, and we go to PRINT label where we print the
; output to the leds. Note that every time we complement carry, cause 
; if not carry will keep coming from MSB to LSB.

		IN 10H
START:		MVI B,08H	; Counter
		LDA 2000H	; Reading from dip switches.
	
FIRST_ONE:	DCR B		; Decrease counter by one
		RAL		; Bringing MSB to Carry flag
		JC FOUND	; First one found
		MOV L,A		; saving A to L	
		MOV A,B		; move B to A so we make
		CPI 00H		; a comparison if B reached 0
		JZ PRINT	; no more digits to check
		MOV A,L		; return the value of A
		JMP FIRST_ONE	; continue the process.

FOUND:		MVI A,FFH	; Filling A with ones
		LOOP_A:	MOV L,A	; saving A to L	
		MOV A,B		; move B to A so we make
		CPI 00H		; a comparison if B reached 0
		JZ PRINT	; If its equal to zero then print
		MOV A,L 	; else moving back A from L and cont
		STC 		; Making sure Carry is eq to 1
		CMC 		; Complementing Carry 
		RAL 		; moving MSB to carry
		DCR B 		; Decreasing B each time
		JMP LOOP_A 	; jumping to loop until B == 0

PRINT:		MOV A,L		; Moving back A from L 
		CMA		; and get the complement so as
		STA 3000H	; we print the right value to the leds. 
		JMP START	; Jumping back to start.Wait for input
END

