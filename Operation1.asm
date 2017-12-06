.include <m128def.inc>
.org 0
		jmp main
.cseg
.org 0x46

;*****
inicio:
			ser 	r16 				;led apagado
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
		sbis PINA, 5	;se PIN A tiver o mesmo valor de SW6= pino 5 
			jmp	OFF
		sbis PINA, 3 	;se PIN A tiver o mesmo valor de SW4= pino 3 
			jmp	ON4
		sbis PINA, 2	;se PIN A tiver o mesmo valor de SW3= pino 2 
			jmp	ON3
		sbis PINA, 1	;se PIN A tiver o mesmo valor de SW2= pino 1 
			jmp	ON2
		sbis PINA, 0	;se PIN A tiver o mesmo valor de SW1= pino 0 
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


	


