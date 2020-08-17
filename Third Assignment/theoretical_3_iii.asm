; First we move R to A.With the first RAL, content of A(which is R) is being shifted left. 
; D7 is going to be the CY flag and previous CY flag is going to be D0. After this action we move A back to R.
; Now we move Q to R. We operate one RAL. Content of A(which now is Q) is being shifted left. D7 is 
; going to be the new CY flag and previous CY flag(which is D7 of R) is going to be D0.

RHLR MACRO Q,R
PUSH PSW			; Pushing A,flags so as their contents are saved
MOV A,R
RAL
MOV R,A
MOV A,Q
RAL
MOV Q,A
POP PSW				; Get back the content of A and flags
ENDM