/*// datasheet 14
// мерцание лампочки
// горение лампочки с заданной яркостью

.org 0
jmp reset

.org 0x14
jmp set0 // по совпадению с регистром сравнения
jmp set1 // по переполнению таймера


reset:
//уазатель стека
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// PC2 выход
sbi DDRC, 2

// Set timer 0
// TCNT - счетный регистр
ldi r16, 0
out TCNT0, r16

// яркость СД - 30 из 255
ldi r16, 30
out OCR0, r16

ldi r16, 1
out TCCR0, r16

ldi r16, (1 << OCIE0) | (1 << TOIE0)
out TIMSK, r16

// разрешаем прерывания
sei

end: rjmp end

set0:
cbi PORTC, 2
reti

set1:
sbi PORTC, 2
reti*/


// Новая задача
// 10 раз в секунду с регистром сравнения 0 таймера что-то делаем

/*.def delta = R17

.org 0
jmp reset
.org 0x0E
jmp changeOCR0

.org 0x14
jmp set0 //По совпадению с регистром сравнения
jmp set1 //По переполнению таймера

reset:
//Указатель стека
ldi r16,low(RAMEND)
out SPL,r16
ldi r16,high(RAMEND)
out SPH,r16

ldi delta,10

//Настройка РС2 на выход
sbi DDRC,2

//Настраиваем таймер0
ldi r16,0
out TCNT0,r16

ldi r16,5
out OCR0,r16

 ldi r16,1
out TCCR0,r16

//Настраиваем таймер1
ldi r16,0
out TCNT1H,r16
out TCNT1L,r16

ldi r16,high(12500)
out OCR1AH,r16
ldi r16,low(12500)
out OCR1AL,r16

 ldi r16,(1<<WGM12)|(1<<CS11)|(1<<CS10)
out TCCR1B,r16

ldi r16,(1<<OCIE0)|(1<<TOIE0)|(1<<OCIE1A)
out TIMSK,r16



//Разрешаем прерывания
sei

end: rjmp end

set0:
cbi PORTC,2
reti

set1:
sbi PORTC,2
reti


changeOCR0:
in r16,OCR0
add r16,delta
cpi r16,240
brsh m1 
out OCR0,r16
reti
m1: neg delta
reti*/

// Новая задача
// pc5 - уменьшаем яркость
// pc6 - увеличиваем яркость
/*.def delta = R17

.org 0
jmp reset
.org 0x0E
jmp changeOCR0

.org 0x14
jmp set0 //По совпадению с регистром сравнения
jmp set1 //По переполнению таймера

reset:
//Указатель стека
ldi r16,low(RAMEND)
out SPL,r16
ldi r16,high(RAMEND)
out SPH,r16

ldi delta,10

//Настройка РС2 на выход
sbi DDRC,2

// PC5 вход
cbi DDRC, 5
sbi PORTC, 5

// PC6 вход
cbi DDRC, 6
sbi PORTC, 6

//Настраиваем таймер0
ldi r16,0
out TCNT0,r16

ldi r16,5
out OCR0,r16

 ldi r16,1
out TCCR0,r16

//Настраиваем таймер1
ldi r16,0
out TCNT1H,r16
out TCNT1L,r16

ldi r16,high(12500)
out OCR1AH,r16
ldi r16,low(12500)
out OCR1AL,r16

 ldi r16,(1<<WGM12)|(1<<CS11)|(1<<CS10)
out TCCR1B,r16

ldi r16,(1<<OCIE0)|(1<<TOIE0)|(1<<OCIE1A)
out TIMSK,r16



//Разрешаем прерывания
sei

end: rjmp end

set0:
cbi PORTC,2
reti

set1:
sbi PORTC,2
reti


changeOCR0:

in r16,OCR0

sbis PINC, 5
rjmp down_click
rjmp down_not_click

down_click:
sub r16, delta
cpi r16, 15
brlo skip
rjmp out_OCR0
down_not_click:


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

reti
*/


// Новая задача
// pc5 - у PC2 уменьшаем яркость, у PC0 - увеличиваем
// pc6 - у PC2 увеличиваем яркость, у PC1 - уменьшаем
.def delta = R17

.org 0
jmp reset
.org 0x0E
jmp changeOCR0

.org 0x14
jmp set0 //По совпадению с регистром сравнения
jmp set1 //По переполнению таймера

reset:
//Указатель стека
ldi r16,low(RAMEND)
out SPL,r16
ldi r16,high(RAMEND)
out SPH,r16

ldi delta,10

//Настройка РС2 на выход
sbi DDRC,2

// PC5 вход
cbi DDRC, 5
sbi PORTC, 5

// PC6 вход
cbi DDRC, 6
sbi PORTC, 6

//Настраиваем таймер0
ldi r16,0
out TCNT0,r16

ldi r16,5
out OCR0,r16

 ldi r16,1
out TCCR0,r16

//Настраиваем таймер1
ldi r16,0
out TCNT1H,r16
out TCNT1L,r16

ldi r16,high(12500)
out OCR1AH,r16
ldi r16,low(12500)
out OCR1AL,r16

 ldi r16,(1<<WGM12)|(1<<CS11)|(1<<CS10)
out TCCR1B,r16

ldi r16,(1<<OCIE0)|(1<<TOIE0)|(1<<OCIE1A)
out TIMSK,r16



//Разрешаем прерывания
sei

end: rjmp end

set0:
cbi PORTC,2
reti

set1:
sbi PORTC,2
reti


changeOCR0:

in r16,OCR0

sbis PINC, 5
rjmp down_click
rjmp down_not_click

down_click:
sub r16, delta
cpi r16, 15
brlo skip
rjmp out_OCR0
down_not_click:


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

reti
