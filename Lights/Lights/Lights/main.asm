// tutor
/*sbi DDRC, 2
sbi PORTC, 5 //подтяжка

loop:
sbis PINC, 5
sbi PORTC, 2
sbic PINC, 5
cbi PORTC, 2
rjmp loop
*/

// lab task 1
/*cbi DDRC, 6 //вход
sbi DDRC, 0 //выход

sbi PORTC, 6 //подтяжка для входа

loop:

sbis PINC, 6
sbi PORTC, 0
sbic PINC, 6
cbi PORTC, 0

rjmp loop*/

//lab task 2
/*cbi DDRC, 5
cbi DDRC, 6
sbi DDRC, 0

sbi PORTC, 5
sbi PORTC, 6

loop:

sbis PINC, 5
sbi PORTC, 0
sbis PINC, 6
cbi PORTC, 0

rjmp loop*/


//lab task 3

//set stack pointer
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

sbi DDRC, 0
sbi DDRC, 1
sbi DDRC, 2

loop:

rcall Delay

ldi R16, 0b00000001
out PORTC, R16

rcall Delay

ldi R16, 0b00000010
out PORTC, R16

rcall Delay

ldi R16, 0b00000100
out PORTC, R16

rjmp loop

Delay:
	ldi R17, 0xFF
	ldi R18, 0xD3
	ldi R19, 0x30

	delay_loop:
	subi R17, 1
	sbci R18, 0
	sbci R19, 0
	brcc delay_loop
	nop
ret
