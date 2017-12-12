.include <m128def.inc>
.org 0
		jmp main
.cseg
.org 0x46

;*****
start:
			ser 	r16 				;The light of LED is OFF
			out 	PORTC,r16
			out		DDRC,r16
			clr		r16
			out		DDRA,r16
			ldi		r16 ,0b11000000
			out		PORTA,r16
			ret

;*****

main:	
	TEST:
		sbis PINA, 5	;if PIN A has the same value as SW6 = pin 5
			jmp	OFF
		sbis PINA, 3 	;if PIN A has the same value as SW4 = pin 3
			jmp	ON4
		sbis PINA, 2	;if PIN A has the same value as SW3 = pin 2
			jmp	ON3
		sbis PINA, 1	;if PIN A has the same value as SW2 = pin 1
			jmp	ON2
		sbis PINA, 0	;if PIN A has the same value as SW1 = pin 0
			jmp	ON1
		jmp TEST
			

ON1:	
		ldi r16, 0b11111111
		out PORTC,r16
		jmp TEST
ON2:	
		ldi r16, 0b01111110
		out PORTC,r16
		jmp TEST
ON3:	
		ldi r16, 0b00111100
		out PORTC,r16
		jmp TEST
ON4:	
		ldi r16, 0b00011000
		out PORTC,r16
		jmp TEST
OFF:
		ser r16
		out PORTC,r16
		jmp TEST


	


