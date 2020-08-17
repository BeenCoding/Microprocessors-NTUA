FILL MACRO ADDR, K
				PUSH PSW			; Pushing A,flags so as their contents are saved
				PUSH D				; Pushing H to the stack so as the contents of HL are saved
				MOV A,K				; Move K to A
				LXI D,ADDR			; Load ADDR to Pair Register DE
				CPI 00H				; Compare A(which is K) if is equal to zero
				JZ ISMAX			; if yes then jmp to ISMAX label
				CPI FFH				; else check if is less than equal to 255
				JC CONTINUE			; if is equal to 255 CONTINUE 
				JZ CONTINUE			; if is less than 255 CONTINUE
				JMP EXIT			; else EXIT, invalid number
ISMAX:			STAX D				; Store A to ADDR(which is stored to DE rp)
				INX D				; Increase ADDR by one
				DCR A				; Decrease A(which is K) by one
CONTINUE:		CPI 00H				; Check if is equal to zero
				JZ EXIT				; if yes then EXIT
				STAX D				; else store A to ADDR(which is stored to DE rp)
				INX D				; Increase ADDR by one
				DCR A				; Decrease A(which is K) by one
				JMP CONTINUE		; and continue the loop
EXIT: 			PUSH D				; Get back the content of Pair Register HL
				POP PSW				; Get back the content of A and flags

ENDM