
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
		test_sw1: ;mm	
					sbis PINA, 	0
					jmp p1					;moves to p1 if you click sw1
					jmp  test_sw1			;restarts the test if you do not click on sw1 goes to p1 if you click on sw1
		p1:			ldi r16,0b11111110		;first position
					out PORTC,r16
					ldi r17,7					;start-up of the counter on and off LEDs sequentially
		cicleROL: ;mm	sec
					call delay500ms
					rol r16					;moves the bits in register r16 to the left
					out PORTC,r16			
					dec r17					;decrements the counter
					brne cicleROL			;let pass only when the counter reaches 0
					ldi r16,0b01111111	    ;Latest Position
					out PORTC,r16
					ldi r23,255				;set r23 to 255
					call delay500ms_2		;if you want to make the sequence do the opposite r23 returns 0
					cpi r23,0
					brne final
					
		test_sw6: ;mm

					ldi r17,7					;start-up of the counter on and off LEDs sequentially
		cicleROR: ;mm	sec
					ror r16						;moves the bits in register r16 to the right
					out PORTC,	r16
					call delay500ms
					dec r17					;decrements the counter
					brne cicleROR			;let pass only when the counter reaches 0

					ldi r16,0b11111110	    ;Latest Position
					out PORTC,r16
					ldi r23,255				;define r24 as 255

					call delay_3		;if you want to make the sequence do the opposite r24 turn 0

					cpi r23,0
					brne final
					ldi r16,0b11111101		;1st place
					out PORTC,r16
					ldi r17,6
					jmp cicleROL			
										
		final:	ldi r25,3    ;contador para piscar 3 vezes
		final1:	ldi r16,0b11100111			;LEDs D4 and D5 are connected
				out PORTC, 	r16
				call delay500ms
				ldi r16,0b11111111			;são desligados os leds todos
				out PORTC, 	r16
				call delay500ms
				dec r25			;All LEDs are off
				brne final1
				jmp test_sw1
				
				
				
		
		
		
		
		
		
delay500ms:  push r18
				push r19
				push r20
				ldi r20, 68

		cicle0: ldi r19, 200
		
		cicle1: ldi r18, 200
		
		cicle2: dec r18
				brne cicle2
				dec r19
				brne cicle1
				dec r20
				brne cicle0

				pop r20
				pop r19
				pop r18
				ret



delay500ms_2:  push r18
				push r19
				push r20
				ldi r20, 68

		cicle0_2: ldi r19, 200
		
		cicle1_2: ldi r18, 200
		
		cicle2_2: dec r18
				sbis PINA ,4				;
				ldi r23,0
				brne cicle2_2
				dec r19
				brne cicle1_2
				dec r20
				brne cicle0_2

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

		cicle0_3: ldi r19, 200
		
		cicle1_3: ldi r18, 200
		
		cicle2_3: dec r18
				brne cicle2_3
				sbis PINA,0
				ldi	 r23,0
				dec r19
				brne cicle1_3
				dec r20
				brne cicle0_3

				//out sreg, r23
				//pop	r23

				pop r20
				pop r19
				pop r18
				ret

