IN 10H
INIT:					MVI A,0DH 		; enable RST 7,5 and 5,5 and interrupts
					SIM 			; set interrupt mask
					MVI A,10H  		; fill memory spaces 0A10-0A13 HEX
					STA 0A10H 		; with 10 (blank print in DCD)	
					STA 0A11H		; so we print the result only on the
					STA 0A12H		; two leftmost digits of the 
					STA 0A13H		; 7segment display
					
INFINITE_LOOP:			EI			; enable interrupt
					JMP INFINITE_LOOP 	; Wait for interrupt
			
		
INTR_ROUTINE:				CALL KIND  		; read input from keyboard
            
DISPLAY:				STA 0A15H 		; Store LSBs to 2nd leftmost disp pos
					RLC			; make 4 left shifts so as the number in
					RLC			; A goes to the 4 most significant bits
					RLC			; The reason is because we want to 
					RLC			; construct the whole number given
					STA 0A16H		; Store the shifted number to 0A16
					CALL KIND		; call kind to read input from keyboard
					STA 0A14H 		; Store LSBs to 2nd leftmost disp pos
					LXI D,0A10H 		; Give Code startin address.
					CALL STDM		; Print the number given from keyboard 
					CALL DCD		; to 7 segment display
					LDA 0A16H		; finalise number by loading back the
					MOV B,A		; number stored in 0A16, moving it to B
					LDA 0A14H		; loading 0A14(second leftmost digit)
					ADD B			; and adding it to B
					MVI C,10H		; Initializing the 3 areas
					MVI D,20H		; by adding numbers to C,D,E
					MVI E,30H		
					CMP C 			; Here we start comparisons so as 
					JC FIRST_CASE		; we see in which area the number 
					JZ FIRST_CASE		; given from keyboard is.
					CMP D			; When found, we print the output
					JC SECOND_CASE	; and return to INFINITE_LOOP 
					JZ SECOND_CASE	; where we wait for an other interrupt.
					CMP E			
					JC THIRD_CASE	
					JZ THIRD_CASE	
FOURTH_CASE:				MVI A,08H 		
					CMA			
					STA 3000H			
					JMP INFINITE_LOOP	
THIRD_CASE:				MVI A,04H 		
					CMA			
					STA 3000H		
					JMP INFINITE_LOOP	
SECOND_CASE:				MVI A,02H 		
					CMA			
					STA 3000H		
					JMP INFINITE_LOOP	
FIRST_CASE:				MVI A,01H 		
					CMA			 
					STA 3000H		
					JMP INFINITE_LOOP	
					
END
					
					
					
					
					
					

