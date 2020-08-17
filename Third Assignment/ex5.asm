			MVI A,0EH			; enable ONLY RST 5,5 and interrupts
			SIM				; interrupt mask

			MVI H,00H			; Init HL pair
			MVI L,00H			; to zero which will hold sum
			MVI B,10H  			; B=16 dec
			MVI D,02H    			; Every time D is zero, it means we read one data packet
					
WAIT_LABEL:		EI				; enable interrupt
			MOV A,B			; Moving B to A so as we can compare if B reached zero
			CPI 00H			; and so we read all data packages.
			JZ TELOS			; if this is true then we jump to TELOS
			JMP WAIT_LABEL		; wait for an other interrupt


INTR_ROUTINE:		DCR D				; decrease D every time so as we know if we read a whole number
			MOV A,D 			; Moving D to A to make the comparison
			CPI 00H			; If zero then we read a full number
			JZ ADDBITS			; so we go to ADDBITS to complete data packet
			IN 20H 			; else we read the half packet(which are MSBs)
			ANI 0FH 			; keep incoming MSbits(X0 - X3)
			RLC 				; 4 rotations
			RLC
			RLC
			RLC
			MOV C,A 			; C has MSBs of Data
			JMP WAIT_LABEL		; wait for an other interrupt
					
ADDBITS:		DCR B       			; B--
			IN 20H 			; read the second half of the packet(LSBs)
			ANI 0FH 			; keep incoming bits(X0 - X3)	
			ADD C				; now we have completed the packet
			MOV E,C			; Moving C to E and 0 to D so as 
			MVI D,00H			; in pair register DE the packet is formed (00000000PACKET)
			DAD D 				; add DE register to HL (HL holds the sum)
			MVI D,02H			; reset D, to read an other packet
			JMP WAIT_LABEL		; wait for an other interrupt
TELOS:			DI 				; disable interrupt
			DAD H  			; By doing 4 DAD H, we move left the number by one every time
			DAD H  			; we did a total of 4 DAD so as to divide the total_sum by
			DAD H  			; 2^(8 - how_many_times_we_used_DAD). At the end, H will have
			DAD H  			; the integer part of average and L will have the nominator of
							; the fraction average (*16)
					
END



