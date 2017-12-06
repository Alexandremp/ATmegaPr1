

		.include<m128def.inc>
		
		;valor dos numeros que são enviados para o display para variáveis
		.equ ZERO=0xC0
		.equ UM=0xF9
		.equ DOIS=0xA4
		.equ TRES=0xB0
		.equ QUATRO=0x99
		.equ CINCO=0x92
		.equ SEIS=0x82
		.equ SETE=0xF8
		.equ OITO=0x80
		.equ NOVE=0x90
		
		.cseg
		.org 0x00
		jmp main
		
		.cseg
		.org 0x46
	delay1ms:	push	r18
				push	r19
				push	r20
		
				ldi	r20,1
		ciclo0:	ldi	r19,29
		ciclo1:	ldi	r18,200
		ciclo2:	dec	r18
				brne	ciclo2
		
				dec	r19
				brne	ciclo1
		
				dec	r20
				brne	ciclo0
		
				pop	r20
				pop	r19
				pop	r18
		
		ini:		ser r17
					out DDRA,	r17
					ldi r17,0b01111111
					out PORTA,	r17
					out DDRC,	r17
					ldi r17,	NOVE
					out PORTC,	r17
					ldi r17,	0b11000000
					out DDRD,	r17
					out PORTD,	r17
					ldi r16,	9    ;r16=contador
					ret

		display:					;função responsável para a representação no display
					nove_:	    			
								cpi  r16, 9			;vê se o contador é 9 
								brne oito_			;se não vai para a função do displat oito_
								ldi  r17, NOVE		;se for o registo r17 vai tomar o valor 0x90 
								jmp  saida
					oito_:
								cpi  r16, 8
								brne sete_
								ldi  r17, OITO
								jmp  saida
					sete_:
								cpi  r16, 7
								brne seis_
								ldi  r17, SETE
								jmp  saida
					seis_:
					 			cpi  r16, 6
								brne cinco_
								ldi  r17, SEIS
								jmp  saida
					cinco_:
								cpi  r16, 5
								brne quatro_
								ldi  r17, CINCO
								jmp  saida
					quatro_:
								cpi  r16, 4
								brne tres_
								ldi  r17, QUATRO
								jmp  saida
					tres_:
								cpi  r16, 3
								brne dois_
								ldi  r17, TRES
								jmp  saida
					dois_:
								cpi  r16, 2
								brne um_
								ldi  r17, DOIS
								jmp  saida
					um_:
								cpi  r16, 1
								brne zero_
								ldi  r17, UM
								jmp  saida
					zero_:
								cpi  r16, 0
								brne saida
								ldi  r17, ZERO
								jmp  saida

					saida:
								out PORTC,	r17			;envia para a portc o registo r17
								ret
	
		main:		ldi r21,	LOW(RAMEND)
	  				out SPL, 	r21
	  				ldi r21,	HIGH(RAMEND)
	  				out SPH,	r21
	  				call ini
		entradasala: 
			p1:		sbis PIND,0			;testa S1 ON
					jmp p2
					jmp p01
			p2:		sbis PIND,4			;testa S2 ON
					jmp	p3
					jmp p1
			p3:		sbic PIND,0			;testa S1 OFF
					jmp p4
					jmp p2
			p4:		sbic PIND,4			;testa S2 OFF
					jmp luz
					jmp p3
			luz:	
					cbi PORTA,6		;liga o led D7 a dizer que a luz da sala está ligada	
					cpi r16,0
					brmi p1		;se r16 tiver um digito menor 0 volta para p1
					cpi r16,0
					breq door1		;se r16 estiver a 0 logo sala está cheia vai para a função onde fecha a porta
					dec r16
					cpi r16,0
					brne chdisplay	;se r16 for maior que zero vai enviar o contador para o display
					 ;fechar a porta
			door1:		sbi PORTA,7		;desliga o led D8 dizendo que a sala está cheia e com porta fechada
			chdisplay:call display
					jmp p1

					//saidasala

			p01:	sbis PIND,4			;testa S2 ON
					jmp p02
					jmp p1
			p02:	sbis PIND,0			;testa S1 ON
					jmp p03
					jmp p01
			p03:	sbic PIND,4			;testa S2 OFF
					jmp p04
					jmp p02
			p04:	sbic PIND,0			;testa S1 OFF
					jmp luz01
					jmp p03
			luz01:	cbi PORTA,7
					cpi r16,9
					brpl p1			;se r16 tiver um digito maior 9 volta para p1
					cpi r16,9		
					breq luzD01		;se r16 estiver a 9 logo sala está vazia vai para a função onde liga a luz
					inc r16
					cpi r16,9		;se r16 for menor que zero vai enviar o contador para o display
					brmi chdisplay01
					
			luzD01:		sbi PORTA,6  ;desligar a luz
			chdisplay01:call display
					jmp p1
			

