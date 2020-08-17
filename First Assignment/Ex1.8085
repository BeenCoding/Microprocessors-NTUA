;Shows how many times the number in A can be divided by 2
;without leaving remainder. To the result is added also the
;last division that will leave a remainder.
;An other use of this program is to show which was the first 
;switch from right to left that was up. The output is shown
;from the leds.

ORG 0800H
		MVI B,01H 	; B <-- 01H
		LDA 2000H 	; Read input from dip switches
		CPI 00H   	; Compare input of dip switches to zero
		JZ LABEL1 	; If z=1 then jump to LABEL1

LABEL3:	RAR			; If last switch is ON then 
		JC LABEL2	; CY=1 then jump to LABEL2
   		INR B		; else b++
   		JNZ LABEL3	; If Z=0 jump LABEL3 else continue

LABEL2:		MOV A,B		; A <-- B

LABEL1: 	CMA		; A --> A complementary	   
		STA 3000H	; [3000H] = A
 		RST 1		
END
