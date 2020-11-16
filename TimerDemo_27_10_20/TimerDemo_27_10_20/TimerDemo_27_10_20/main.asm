/*// ������� ����������� � �������� 1 ��
// ���� �� PC0
// ������� ����������� 8 ���

.org 0x00 //������� ����������� ��������� ��� ������ �� ��������� ������ (������� � ��������� ������)
jmp reset
.org 0x0E 
jmp timer

reset:
// ���������� ��������� ����� (�� ��������� ������� ����������� ������)
// SP - stack pointer (16-bit), SPL - low SP, SPH - high SP
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// ����������� ���� C0 �� �����
sbi DDRC, 0
cbi PORTC, 0

// ����������� ������ 1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// ������ ������������ � 64
// �������� ������ ��� ���������� � ��������� ��������� OCR1A
ldi r16, (1 << CS10) | (1 << CS11) | (1 << WGM12)
// or 
// ldi r16, 0b00001011
out TCCR1B, r16

// ����������� ������� ��������� OCR1A
ldi r16, high(62500)
out OCR1AH, r16
ldi r16, low(62500)
out OCR1AL, r16

// ��������� ���������� �� ���������� � ��������� ���������
ldi r16, (1 << OCIE1A)
out TIMSK, r16

// ��� �������
ldi r17, 0b00000001

// ��������� ��� ����������
// ������ ��� i � 1
sei

end: rjmp end

timer:
in r16, PINC
eor r16, r17
out PORTC, r16
reti // ����� �� ����������� ����������*/

/*// Task 1

// ������� ����������� � �������� 2 ��
// ���� �� PC1
// ������� ����������� 8 ���

.org 0x00 //������� ����������� ��������� ��� ������ �� ��������� ������ (������� � ��������� ������)
jmp reset
.org 0x0E 
jmp timer

reset:
// ���������� ��������� ����� (�� ��������� ������� ����������� ������)
// SP - stack pointer (16-bit), SPL - low SP, SPH - high SP
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// ����������� ���� C1 �� �����
sbi DDRC, 1
cbi PORTC, 1

// ����������� ������ 1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// ������ ������������ � 64
// �������� ������ ��� ���������� � ��������� ��������� OCR1A
ldi r16, (1 << CS10) | (1 << CS11) | (1 << WGM12)
// or 
// ldi r16, 0b00001011
out TCCR1B, r16

// ����������� ������� ��������� OCR1A
ldi r16, high(31250)
out OCR1AH, r16
ldi r16, low(31250)
out OCR1AL, r16

// ��������� ���������� �� ���������� � ��������� ���������
ldi r16, (1 << OCIE1A)
out TIMSK, r16

// ��� �������
ldi r17, 0b00000010

// ��������� ��� ����������
// ������ ��� i � 1
sei

end: rjmp end

timer:
in r16, PINC
eor r16, r17
out PORTC, r16
reti // ����� �� ����������� ����������

*/

// Task 2

// �������� ��� ������� �� ������
// ���� �� PC1
// ������� ����������� 8 ���

.org 0x00 //������� ����������� ��������� ��� ������ �� ��������� ������ (������� � ��������� ������)
jmp reset
.org 0x0E 
jmp timer

reset:
// ���������� ��������� ����� (�� ��������� ������� ����������� ������)
// SP - stack pointer (16-bit), SPL - low SP, SPH - high SP
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

// ����������� ���� C1 �� �����
sbi DDRC, 1
cbi PORTC, 1

// PC 5 �� ���� �� ����������
cbi DDRC, 5
sbi PORTC, 5

// PC6 �� ���� �� ����������
cbi DDRC, 6
sbi PORTC, 6

// ����������� ������ 1
ldi r16, 0
out TCNT1H, r16
out TCNT1L, r16

// ������ ������������ � 64
// �������� ������ ��� ���������� � ��������� ��������� OCR1A
ldi r16, (1 << CS10) | (1 << CS11) | (1 << WGM12)
// or 
// ldi r16, 0b00001011
out TCCR1B, r16

// ����������� ������� ��������� OCR1A
ldi r16, high(31250)
out OCR1AH, r16
ldi r16, low(31250)
out OCR1AL, r16

// ��������� ���������� �� ���������� � ��������� ���������
ldi r16, (1 << OCIE1A)
out TIMSK, r16

// ��� �������
ldi r17, 0b00000010

// ��������� ��� ����������
// ������ ��� i � 1
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

reti // ����� �� ����������� ����������
