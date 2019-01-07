[org 0x0100]

mov AL, 3
mov [Table], AL

add AL, 3
mov [Table + 1], AL
add AL, 3
mov [Table + 2], AL
add AL, 3
mov [Table + 3], AL
add AL, 3
mov [Table + 4], AL

int 0x21

Table: Times 5 db 0