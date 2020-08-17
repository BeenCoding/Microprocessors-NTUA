					IN 10H
INIT:					MVI A,0DH		; enable RST 7,5 and 5,5 and interrupts
					SIM 			; interrupt mask
					LXI B,00FAH		; 250ms.Initiate E to 60dec.
					MVI A,3CH		; Because 60*(250ms+250ms+250ms+250ms) = 60s
					STA 0A16H 		; store timer counter to 0A16H
					MVI A,10H		; fill memory spaces 0A12-0A15 HEX
					STA 0A12H		; with 10 (blank print in DCD)
					STA 0A13H		; because we want to show our result
					STA 0A14H		; to the two rightmost bits which are
					STA 0A15H		; 0A10H and 0A11H

INFINITE_LOOP:			EI			; enable interrupt
					JMP INFINITE_LOOP	; Wait for interrupt

INTR_ROUTINE:				MVI A,3CH		; Because 60*(250ms+250ms+250ms+250ms) = 60s
					STA 0A16H 		; store 60 dec in 0A16H
FLICKER:
					CALL DISPLAY		; Display TIME
					MVI A,00H 		; Making sure A is Zero, so flicker is right
					STA 3000H		; print complement of A(11111111)
					CALL DELB		; delay to see result
					CMA			; complement zero so in outport 00000000 is 
					STA 3000H 		; shown.
					CALL DELB 		; delay to see result
					CMA			; complement zero so in outport 00000000 is 
					STA 3000H 		; shown.
					CALL DELB 		; delay to see result
					STA 3000H 		; shown.
					CALL DELB 		; delay to see result
					EI			; Restart the timer if interrupted.
					LDA 0A16H		; load the counter to reg A
					DCR A			; decrease timer counter
					STA 0A16H 		; store back the updated value of counter
					CPI 00H		; Check A with zero.If yes then go back to "??FINITE_LOOP"  
					JZ INFITE_LOOP	; and wait for an another interrupt
					JMP FLICKER		; else keep flickering ;)

DISPLAY:				LDA 0A16H		; Temporary move of time counter to A
					MVI H,00H		; init H to zero -- which is our counter for tens

TENS:					CPI 0AH		; compare input with 10
					JC UNITS		; if A is less than 10 then we have no tens
					SUI 0AH		; Subtract 10 from accumulator(input)
					INR H			; tens++
					JMP TENS		; loop until no more TENS exist

UNITS:					STA 0A10H		; if we reached this point, then inside A are only units
					MOV A,H		; moving tens to A so as we store them
					STA 0A11H		; Store decades to 2nd rightmost display pos
					LXI D,0A10H		; Give Code startin address.
					CALL STDM		; Do the printing in the 7segment display
					CALL DCD		; 
					RET
END