.def temp_0 = r16
.def delta = r17
.def switcher = r18
.def temp_1 = r19

.org 0
jmp reset

// timer
.org 0x0E
jmp changeOCR0

// PWR
.org 0x14
jmp set0 // by coincidence with comparison register
jmp set1 // by timer overflow

reset:
// set stack pointer
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

ldi delta, 10

// set PC0 output
sbi DDRC, 0
cbi PORTC, 0

// set PC1 output
sbi DDRC, 1
cbi PORTC, 1

// set PC2 output
sbi DDRC, 2
cbi PORTC, 2

// set PC5 input
cbi DDRC, 5
sbi PORTC, 5

// set PC6 input
cbi DDRC, 6
sbi PORTC, 6

// set PC7 input
cbi DDRC, 7
sbi PORTC, 7

//set timer_0
ldi r16, 0
out TCNT0, r16

ldi r16, 5
out OCR0, r16

ldi r16, 1
out TCCR0, r16

//set timer_1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// 4 Hz
ldi r16, high(15625)
out OCR1AH, r16
ldi r16, low(15625)
out OCR1AL, r16

ldi r16, (1<<WGM12)|(1<<CS11)|(1<<CS10)
out TCCR1B, r16

ldi r16, (1<<OCIE0)|(1<<TOIE0)|(1<<OCIE1A)
out TIMSK, r16

// set switcher
ldi switcher, 0b00000111

// enable interruptions
sei

end: rjmp end


set0:

// disable all lights
cbi PORTC,0
cbi PORTC,1
cbi PORTC,2

reti


set1:

// enable necessary lights
in r16,PORTC
mov temp_1, switcher
com temp_1
and temp_1, r16
or temp_1, switcher
out PORTC, temp_1

reti


// handle button clicks
changeOCR0:

in r16, OCR0

// decrease frequency
sbis PINC, 5
rjmp down_click
rjmp down_not_click

down_click:
sub r16, delta
cpi r16, 15
brlo skip
rjmp out_OCR0
down_not_click:

// increase frequency
sbis PINC, 6
rjmp up_click
rjmp up_not_click

up_click:
add r16, delta
cpi r16, 240
brsh skip
rjmp out_OCR0
up_not_click:

rjmp skip

out_OCR0:

out OCR0, r16

skip:

// set next mode
sbis PINC, 7
rjmp next_click
rjmp next_not_click

next_click:
ldi r16, 1
add switcher, r16
cpi switcher, 0b0001000
brlo next_not_click
ldi switcher, 0
next_not_click:

reti
