[org 0x0100]

mov AL, 3
mov BL, [Table]
mul BL
mov [Table], AL

mov AL, 3
mov BL, [Table + 1]
mul BL
mov [Table + 1], AL

mov AL, 3
mov BL, [Table + 2]
mul BL
mov [Table + 2], AL

mov AL, 3
mov BL, [Table + 3]
mul BL
mov [Table + 3], AL

mov AL, 3
mov BL, [Table + 4]
mul BL
mov [Table + 4], AL


int 0x21

Table: db 1,2,3,4,5