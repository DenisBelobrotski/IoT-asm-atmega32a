.org 0
jmp reset

.org 0x14
jmp set0 // �� ���������� � ��������� ���������
jmp set1 // �� ������������ �������


reset:
//�������� �����
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// PC3 �����
sbi DDRC, 3
cbi PORTC, 3

//����������� ������1
ldi r16,0
out TCNT1H,r16
out TCNT1L,r16

// 15625 - 4 hz, 31250 - 2 hz
ldi r16,high(100)
out OCR1AH,r16
ldi r16,low(100)
out OCR1AL,r16

ldi r16,(1<<WGM12)|(1<<CS11)|(1<<CS10)
out TCCR1B,r16

ldi r16,(1<<OCIE0)|(1<<TOIE0)|(1<<OCIE1A)
out TIMSK,r16

// ��������� ����������
sei

end: rjmp end

set0:
cbi PORTC, 3
reti

set1:
sbi PORTC, 3
reti
