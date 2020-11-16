//Настраиваем прерывания
.org 0
jmp reset
.org 0x1C //когда UDR становится пустым, то здесь возникает прерывание (см. даташит)
jmp send_data

reset:

// настраиваем указатель стека
ldi r16,high(RAMEND)
out SPH,r16
ldi r16,low(RAMEND)
out SPL,r16

//Настраиваем скорость работы USART 9600
ldi r16,0
out UBRRH,r16
ldi r16,51
out UBRRL,r16

// UDRIE разрешает прерывание, если UDR пустой
//
// TXEN разрешение на передачу
// TXCIE включает прерываение на передачу
//
// RXEN разрешение на прием
// RXCIE включает прерывание на прием
//
ldi r16,(1<<UDRIE)|(1<<TXEN)
out UCSRB,r16

// PC0 на вход
cbi DDRC, 0
sbi PORTC, 0
// PC1 на вход
cbi DDRC, 1
sbi PORTC, 1
// PC2 на вход
cbi DDRC, 2
sbi PORTC, 2

// биты для определения набора посылаемых сообщений
ldi r20, 0b00000000

// обнуляем регистр для указателя на текст
ldi ZH, 0
ldi ZL, 0

loop:

cpi r20, 0b00000000

//debug simulator
brne debug //***

brne loop

ldi ZH, 0
ldi ZL, 0

sbis PINC, 0
rjmp button_0_click
rjmp button_0_not_click

button_0_click:
ldi r16, 0b00000001
or r20, r16
button_0_not_click:

sbis PINC, 1
rjmp button_1_click
rjmp button_1_not_click

button_1_click:
ldi r16, 0b00000010
or r20, r16
button_1_not_click:

sbis PINC, 2
rjmp button_2_click
rjmp button_2_not_click

button_2_click:
ldi r16, 0b00000100
or r20, r16
button_2_not_click:

//debug simulator
rjmp debug //***
end_debug: //***

rjmp loop



debug: //***
send_data:

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
rjmp end_debug //***

reti

//no_button_text:
//.db "no_buttons:"
//end_no_button_text:

button_text_1:
.db "button_1:"
end_button_text_1:

button_text_2:
.db "button_2:"
end_button_text_2:

button_text_3:
.db "button_3:"
end_button_text_3:
