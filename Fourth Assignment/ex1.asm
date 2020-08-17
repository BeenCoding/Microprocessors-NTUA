; Εxercise 1, Set 4 microprocessors
; Created: 22/05/2020 16:22:05
; Author : Team65 (03117711,03117715,03117070)
; A program that makes the led move from lsb to msb, and 
; then make the reverse move , from msb to lsb.
; When PC2 is pressed the cyclic move stops until released.

.include "m16def.inc"
.def setter = r20						; register to determine I/O
.def LEDB = r21							; define r21 as LedB
.def push_button = r25					; define push_button as r25

main:			ser setter				; init to 0B11111111
				out DDRB,setter 		; set port B as output
				LDI LEDB,0x01			; init LEDB to 1
				out PORTB,LEDB			; set first led (msb) as on.
				clr setter				; clear setter to init PORTC
				out DDRC,setter			; Now DDRC is set with 0B00000000
left_loop:		lsl LEDB				; left shift, to turn on next led
stop_button1:	IN push_button,PINC		; read from PINC
				cpi push_button,0x04	; compare PINC with 4, to check if PC2 is pressed.
				breq stop_button1		; If yes then loop to stop_button1 until the button is released.
				out PORTB,LEDB			; If no print the output
				cpi LEDB,128			; Check if LEDB is equal to 128. If yes then 
				breq right_loop			; we need to move from MSB to LSB so jump to right_loop
				rjmp left_loop			; else continue looping until LEDB has value 128.
right_loop:		lsr LEDB				; Right shift to make the opposite move
stop_button2:	IN push_button,PINC		; read from PINC
				cpi push_button,0x04	; compare PINC with 4, to check if PC2 is pressed.
				breq stop_button2		; If yes then loop to stop_button2 until the button is released.
				out PORTB,LEDB			; If no print the output
				cpi LEDB,1				; Check if LEDB is equal to 1. If yes then 
				breq left_loop			; we need to move from LSB to MSB so jump to left_loop
				rjmp right_loop			; else continue looping until LEDB has value 1.
