//Настраиваем прерывания
.org 0
jmp reset
.org 0x1C //когда UDR становится пустым, то здесь возникает прерывание (см. даташит)
jmp send_data

reset:

// настраиваем указатель стека
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16

//Настраиваем скорость работы USART 9600
ldi r16, 0
out UBRRH, r16
ldi r16, 51
out UBRRL, r16

// UDRIE разрешает прерывание, если UDR пустой
//
// TXEN разрешение на передачу
// TXCIE включает прерываение на передачу
//
// RXEN разрешение на прием
// RXCIE включает прерывание на прием
//
ldi r16, (1<<UDRIE)|(1<<TXEN)
out UCSRB, r16

// PC5 на вход
cbi DDRC, 5
sbi PORTC, 5
// PC6 на вход
cbi DDRC, 6
sbi PORTC, 6
// PC7 на вход
cbi DDRC, 7
sbi PORTC, 7

// PC0 на выход
sbi DDRC, 0
// PC1 на выход
sbi DDRC, 1
// PC2 на выход
sbi DDRC, 2

// биты для определения набора посылаемых сообщений
ldi r20, 0b00000000

// обнуляем регистр для указателя на текст
ldi ZH, 0
ldi ZL, 0

// включаем прерывания
sei

loop:

cpi r20, 0b00000000

//debug simulator
//brne debug //***

brne loop

// reset Z
ldi ZH, 0
ldi ZL, 0

// check button 1 (PC5)
sbis PINC, 5
rjmp button_0_click
rjmp button_0_not_click

button_0_click:
ldi r16, 0b00000001
or r20, r16
button_0_not_click:

// check button 2 (PC6)
sbis PINC, 6
rjmp button_1_click
rjmp button_1_not_click

button_1_click:
ldi r16, 0b00000010
or r20, r16
button_1_not_click:

// check button 3 (PC7)
sbis PINC, 7
rjmp button_2_click
rjmp button_2_not_click

button_2_click:
ldi r16, 0b00000100
or r20, r16
button_2_not_click:

//debug simulator
//rjmp debug //***
//end_debug: //***

rjmp loop



//debug: //***
send_data:

// check interruption and buttons

// PC5 + PC0
sbis PINC, 5
sbi PORTC, 0
sbic PINC, 5
cbi PORTC, 0

// PC6 + PC1
sbis PINC, 6
sbi PORTC, 1
sbic PINC, 6
cbi PORTC, 1

// PC7 + PC2
sbis PINC, 7
sbi PORTC, 2
sbic PINC, 7
cbi PORTC, 2


// send some "empty" data
// working only while buttons not clicked
ldi r16, 42 // sybol "*"
out UDR, r16


// check has some data already sending
cpi ZH, 0
brne already_sending
cpi ZL, 0
brne already_sending

// check is button 1 clicked
ldi r16, 0b00000001
and r16, r20
cpi r16, 0b00000001
brne skip_button_1_start

// set data pointer
ldi ZH, high(button_text_1 * 2)
ldi ZL, low(button_text_1 * 2)
// send data
lpm r16,Z+
out UDR,r16
// TODO: check end of text
// sending completed
rjmp end_send_data

skip_button_1_start:


// check is button 2 clicked
ldi r16, 0b00000010
and r16, r20
cpi r16, 0b00000010
brne skip_button_2_start

// set data pointer
ldi ZH, high(button_text_2 * 2)
ldi ZL, low(button_text_2 * 2)
// send data
lpm r16,Z+
out UDR,r16
// TODO: check end of text
// sending completed
rjmp end_send_data

skip_button_2_start:


// check is button 3 clicked
ldi r16, 0b00000100
and r16, r20
cpi r16, 0b00000100
brne skip_button_3_start

// set data pointer
ldi ZH, high(button_text_3 * 2)
ldi ZL, low(button_text_3 * 2)
// send data
lpm r16,Z+
out UDR,r16
// TODO: check end of text
// sending completed
rjmp end_send_data

skip_button_3_start:

rjmp end_send_data

already_sending:


// check is button 1 sending
ldi r16, 0b00000001
and r16, r20
cpi r16, 0b00000001
brne skip_button_1_send

// send button 1 text
lpm r16, Z+
out UDR, r16

// check is button 1 text ended
cpi ZH, high(end_button_text_1 * 2)
brne end_send_data
cpi ZL, low(end_button_text_1 * 2)
brne end_send_data

// clear bit
ldi r16, 0b11111110
and r20, r16

// clear text pointer
ldi ZH, 0
ldi ZL, 0

rjmp end_send_data

skip_button_1_send:


// check is button 2 sending
ldi r16, 0b00000010
and r16, r20
cpi r16, 0b00000010
brne skip_button_2_send

// send button 2 text
lpm r16, Z+
out UDR, r16

// check is button 2 text ended
cpi ZH, high(end_button_text_2 * 2)
brne end_send_data
cpi ZL, low(end_button_text_2 * 2)
brne end_send_data

// clear bit
ldi r16, 0b11111101
and r20, r16

// clear text pointer
ldi ZH, 0
ldi ZL, 0

rjmp end_send_data

skip_button_2_send:


// check is button 3 sending
ldi r16, 0b00000100
and r16, r20
cpi r16, 0b00000100
brne skip_button_3_send

// send button 3 text
lpm r16, Z+
out UDR, r16

// check is button 3 text ended
cpi ZH, high(end_button_text_3 * 2)
brne end_send_data
cpi ZL, low(end_button_text_3 * 2)
brne end_send_data

// clear bit
ldi r16, 0b11111011
and r20, r16

// clear text pointer
ldi ZH, 0
ldi ZL, 0

rjmp end_send_data

skip_button_3_send:


end_send_data:

// debug simulator
//rjmp end_debug //***

reti

button_text_1:
.db "button_1:"
end_button_text_1:

button_text_2:
.db "button_2:"
end_button_text_2:

button_text_3:
.db "button_3:"
end_button_text_3:
