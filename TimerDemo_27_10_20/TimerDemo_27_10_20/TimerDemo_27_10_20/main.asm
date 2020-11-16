/*// Моргаем светодиодом с частотой 1 Гц
// Диод на PC0
// Частота контроллера 8 МГц

.org 0x00 //говорит компилятору поместить код именно по заданному адресу (начиная с заданного адреса)
jmp reset
.org 0x0E 
jmp timer

reset:
// установить указатель стека (на последнюю область оперативной памяти)
// SP - stack pointer (16-bit), SPL - low SP, SPH - high SP
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// Настраиваем порт C0 на выход
sbi DDRC, 0
cbi PORTC, 0

// Настраиваем таймер 1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// Ставим предделитель в 64
// Обнуляем таймер при совпадении с регистром сравнения OCR1A
ldi r16, (1 << CS10) | (1 << CS11) | (1 << WGM12)
// or 
// ldi r16, 0b00001011
out TCCR1B, r16

// Настраиваем регистр сравнения OCR1A
ldi r16, high(62500)
out OCR1AH, r16
ldi r16, low(62500)
out OCR1AL, r16

// Разрешаем прерывание по совпадению с регистром сравнения
ldi r16, (1 << OCIE1A)
out TIMSK, r16

// для таймера
ldi r17, 0b00000001

// Разрешаем все прерывания
// Ставит бит i в 1
sei

end: rjmp end

timer:
in r16, PINC
eor r16, r17
out PORTC, r16
reti // выход из обработчика прерываний*/

/*// Task 1

// Моргаем светодиодом с частотой 2 Гц
// Диод на PC1
// Частота контроллера 8 МГц

.org 0x00 //говорит компилятору поместить код именно по заданному адресу (начиная с заданного адреса)
jmp reset
.org 0x0E 
jmp timer

reset:
// установить указатель стека (на последнюю область оперативной памяти)
// SP - stack pointer (16-bit), SPL - low SP, SPH - high SP
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// Настраиваем порт C1 на выход
sbi DDRC, 1
cbi PORTC, 1

// Настраиваем таймер 1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// Ставим предделитель в 64
// Обнуляем таймер при совпадении с регистром сравнения OCR1A
ldi r16, (1 << CS10) | (1 << CS11) | (1 << WGM12)
// or 
// ldi r16, 0b00001011
out TCCR1B, r16

// Настраиваем регистр сравнения OCR1A
ldi r16, high(31250)
out OCR1AH, r16
ldi r16, low(31250)
out OCR1AL, r16

// Разрешаем прерывание по совпадению с регистром сравнения
ldi r16, (1 << OCIE1A)
out TIMSK, r16

// для таймера
ldi r17, 0b00000010

// Разрешаем все прерывания
// Ставит бит i в 1
sei

end: rjmp end

timer:
in r16, PINC
eor r16, r17
out PORTC, r16
reti // выход из обработчика прерываний

*/

// Task 2

// Ускоряем при нажатии на кнопку
// Диод на PC1
// Частота контроллера 8 МГц

.org 0x00 //говорит компилятору поместить код именно по заданному адресу (начиная с заданного адреса)
jmp reset
.org 0x0E 
jmp timer

reset:
// установить указатель стека (на последнюю область оперативной памяти)
// SP - stack pointer (16-bit), SPL - low SP, SPH - high SP
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// Настраиваем порт C1 на выход
sbi DDRC, 1
cbi PORTC, 1

// PC 5 на вход на уменьшение
cbi DDRC, 5
sbi PORTC, 5

// PC6 на вход на увеличение
cbi DDRC, 6
sbi PORTC, 6

// Настраиваем таймер 1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// Ставим предделитель в 64
// Обнуляем таймер при совпадении с регистром сравнения OCR1A
ldi r16, (1 << CS10) | (1 << CS11) | (1 << WGM12)
// or 
// ldi r16, 0b00001011
out TCCR1B, r16

// Настраиваем регистр сравнения OCR1A
ldi r16, high(31250)
out OCR1AH, r16
ldi r16, low(31250)
out OCR1AL, r16

// Разрешаем прерывание по совпадению с регистром сравнения
ldi r16, (1 << OCIE1A)
out TIMSK, r16

// для таймера
ldi r17, 0b00000010

// Разрешаем все прерывания
// Ставит бит i в 1
sei

end: rjmp end

timer:

sbis PINC, 5
rjmp decrease
sbis PINC, 6
rjmp increase

decrease:
in r16, OCR1AL
in r17, OCR1AH
//add 1
rjmp light

increase:
//sub 1
rjmp light

light:
in r16, PINC
eor r16, r17
out PORTC, r16

reti // выход из обработчика прерываний
