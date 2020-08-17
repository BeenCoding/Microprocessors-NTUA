INR16 MACRO ADDR
PUSH PSW			; Pushing A,flags so as their contents are saved
PUSH H				; Pushing H to the stack so as the contents of HL are saved
LHLD ADDR			; Load ADDR to Pair Register HL
INX H				; Increase the content of Pair Register HL
SHLD ADDR			; Store Pair Register HL to ADDR
POP H				; Get back the content of Pair Register HL
POP PSW				; Get back the content of A and flags
ENDM