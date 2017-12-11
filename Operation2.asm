
 		.include <m128def.inc>

		.cseg
		.org 0x00
		jmp main
		
		.cseg
		.org 0x46

		ini: 		clr r16
					out PORTA,	r16
					out DDRA,	r16
					ser r16
					out DDRC,	r16
					clr r16
					out PORTC,	r16
					ldi r17,7
					ret


		main:		ldi r16,	LOW(RAMEND)
	  				out SPL, 	r16
	  				ldi r16,	HIGH(RAMEND)
	  				out SPH,	r16
	  				call ini	
		teste_sw1:	
					sbis PINA, 	0
					jmp p1					;moves to p1 if you click sw1
					jmp  teste_sw1			;restarts the test if you do not click on sw1 goes to p1 if you click on sw1
		p1:			ldi r16,0b11111110		;first position
					out PORTC,r16
					ldi r17,7					;start-up of the counter on and off LEDs sequentially
		cicloROL:	sec
					call delay500ms
					rol r16					;moves the bits in register r16 to the left
					out PORTC,r16			
					dec r17					;decrements the counter
					brne cicloROL			;let pass only when the counter reaches 0
					ldi r16,0b01111111	    ;Latest Position
					out PORTC,r16
					ldi r23,255				;set r23 to 255
					call delay500ms_2		;if you want to make the sequence do the opposite r23 returns 0
					cpi r23,0
					brne final
					
		teste_sw6:

					ldi r17,7					;start-up of the counter on and off LEDs sequentially
		cicloROR:	sec
					ror r16						;moves the bits in register r16 to the right
					out PORTC,	r16
					call delay500ms
					dec r17					;decrements the counter
					brne cicloROR			;let pass only when the counter reaches 0

					ldi r16,0b11111110	    ;Latest Position
					out PORTC,r16
					ldi r23,255				;define r24 as 255

					call delay_3		;if you want to make the sequence do the opposite r24 turn 0

					cpi r23,0
					brne final
					ldi r16,0b11111101		;1st place
					out PORTC,r16
					ldi r17,6
					jmp cicloROL			
										
		final:	ldi r25,3    ;contador para piscar 3 vezes
		final1:	ldi r16,0b11100111			;LEDs D4 and D5 are connected
				out PORTC, 	r16
				call delay500ms
				ldi r16,0b11111111			;são desligados os leds todos
				out PORTC, 	r16
				call delay500ms
				dec r25			;All LEDs are off
				brne final1
				jmp teste_sw1
				
				
				
		
		
		
		
		
		
delay500ms:  push r18
				push r19
				push r20
				ldi r20, 68

		ciclo0: ldi r19, 200
		
		ciclo1: ldi r18, 200
		
		ciclo2: dec r18
				brne ciclo2
				dec r19
				brne ciclo1
				dec r20
				brne ciclo0

				pop r20
				pop r19
				pop r18
				ret



delay500ms_2:  push r18
				push r19
				push r20
				ldi r20, 68

		ciclo0_2: ldi r19, 200
		
		ciclo1_2: ldi r18, 200
		
		ciclo2_2: dec r18
				sbis PINA ,4				;
				ldi r23,0
				brne ciclo2_2
				dec r19
				brne ciclo1_2
				dec r20
				brne ciclo0_2

				pop r20
				pop r19
				pop r18
				ret

delay_3:		push r18
				push r19
				push r20

				//push r23
				//in	r23, sreg
				ldi r20, 68

		ciclo0_3: ldi r19, 200
		
		ciclo1_3: ldi r18, 200
		
		ciclo2_3: dec r18
				brne ciclo2_3
				sbis PINA,0
				ldi	 r23,0
				dec r19
				brne ciclo1_3
				dec r20
				brne ciclo0_3

				//out sreg, r23
				//pop	r23

				pop r20
				pop r19
				pop r18
				ret

