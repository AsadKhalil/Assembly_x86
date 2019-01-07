[org 0x0100]

mov AX, 33
mov BX, 33
mov CX, 33

not AX

XOR BX, 0xFFFF

neg CX

sub CX, 1


int 0x21