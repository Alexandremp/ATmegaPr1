
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
					jmp p1					;segue para o p1 se clicar em sw1
					jmp  teste_sw1			;reinicia o teste se não clicar no sw1
		p1:			ldi r16,0b11111110		;1ºposição
					out PORTC,r16
					ldi r17,7					;iniciação do contador de ligar e desligar LEDs sequencialmente
		cicloROL:	sec
					call delay500ms
					rol r16					;movimenta os bits no registo r16 para a esquerda
					out PORTC,r16			
					dec r17					;decrementa o contador
					brne cicloROL			;deixa passar só quando o contador chegar a 0
					ldi r16,0b01111111	    ;ultíma posição
					out PORTC,r16
					ldi r23,255				;define r23 como 255
					call delay500ms_2		;se quiser fazer com que a sequência faça o contrario r23 volta 0
					cpi r23,0
					brne final
					
		teste_sw6:

					ldi r17,7					;iniciação do contador de ligar e desligar LEDs sequencialmente
		cicloROR:	sec
					ror r16						;movimenta os bits no registo r16 para a direita
					out PORTC,	r16
					call delay500ms
					dec r17					;decrementa o contador
					brne cicloROR			;deixa passar só quando o contador chegar a 0

					ldi r16,0b11111110	    ;ultíma posição
					out PORTC,r16
					ldi r23,255				;define r24 como 255

					call delay_3		;se quiser fazer com que a sequência faça o contrario r24 volta 0

					cpi r23,0
					brne final
					ldi r16,0b11111101		;1ºposição
					out PORTC,r16
					ldi r17,6
					jmp cicloROL			
										
		final:	ldi r25,3    ;contador para piscar 3 vezes
		final1:	ldi r16,0b11100111			;são ligado os leds D4 e D5
				out PORTC, 	r16
				call delay500ms
				ldi r16,0b11111111			;são desligados os leds todos
				out PORTC, 	r16
				call delay500ms
				dec r25			;decrementa o contador
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

