/*// datasheet 14
// �������� ��������
// ������� �������� � �������� ��������

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

// PC2 �����
sbi DDRC, 2

// Set timer 0
// TCNT - ������� �������
ldi r16, 0
out TCNT0, r16

// ������� �� - 30 �� 255
ldi r16, 30
out OCR0, r16

ldi r16, 1
out TCCR0, r16

ldi r16, (1 << OCIE0) | (1 << TOIE0)
out TIMSK, r16

// ��������� ����������
sei

end: rjmp end

set0:
cbi PORTC, 2
reti

set1:
sbi PORTC, 2
reti*/


// ����� ������
// 10 ��� � ������� � ��������� ��������� 0 ������� ���-�� ������

/*.def delta = R17

.org 0
jmp reset
.org 0x0E
jmp changeOCR0

.org 0x14
jmp set0 //�� ���������� � ��������� ���������
jmp set1 //�� ������������ �������

reset:
//��������� �����
ldi r16,low(RAMEND)
out SPL,r16
ldi r16,high(RAMEND)
out SPH,r16

ldi delta,10

//��������� ��2 �� �����
sbi DDRC,2

//����������� ������0
ldi r16,0
out TCNT0,r16

ldi r16,5
out OCR0,r16

 ldi r16,1
out TCCR0,r16

//����������� ������1
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



//��������� ����������
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

// ����� ������
// pc5 - ��������� �������
// pc6 - ����������� �������
/*.def delta = R17

.org 0
jmp reset
.org 0x0E
jmp changeOCR0

.org 0x14
jmp set0 //�� ���������� � ��������� ���������
jmp set1 //�� ������������ �������

reset:
//��������� �����
ldi r16,low(RAMEND)
out SPL,r16
ldi r16,high(RAMEND)
out SPH,r16

ldi delta,10

//��������� ��2 �� �����
sbi DDRC,2

// PC5 ����
cbi DDRC, 5
sbi PORTC, 5

// PC6 ����
cbi DDRC, 6
sbi PORTC, 6

//����������� ������0
ldi r16,0
out TCNT0,r16

ldi r16,5
out OCR0,r16

 ldi r16,1
out TCCR0,r16

//����������� ������1
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



//��������� ����������
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


// ����� ������
// pc5 - � PC2 ��������� �������, � PC0 - �����������
// pc6 - � PC2 ����������� �������, � PC1 - ���������
.def delta = R17

.org 0
jmp reset
.org 0x0E
jmp changeOCR0

.org 0x14
jmp set0 //�� ���������� � ��������� ���������
jmp set1 //�� ������������ �������

reset:
//��������� �����
ldi r16,low(RAMEND)
out SPL,r16
ldi r16,high(RAMEND)
out SPH,r16

ldi delta,10

//��������� ��2 �� �����
sbi DDRC,2

// PC5 ����
cbi DDRC, 5
sbi PORTC, 5

// PC6 ����
cbi DDRC, 6
sbi PORTC, 6

//����������� ������0
ldi r16,0
out TCNT0,r16

ldi r16,5
out OCR0,r16

 ldi r16,1
out TCCR0,r16

//����������� ������1
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



//��������� ����������
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
