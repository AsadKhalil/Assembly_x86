[org 0x0100]

jmp start

day: dw 31
month: dw 12
year: dw 85



;this function will pack the given data into the required format
;and return the output in the ax register
encode:
;order of pushing data:	day, month, year

	;for keeping a reference in the stack
	push bp
	mov bp, sp
	
	;saving registers
	push bx
	
	xor bx, bx
	
	xor ax, ax	;setting ax to 0
	
	mov ax, [bp + 6]	;moving month in bx
	shl ax, 12
	
	mov bx, ax
	
	xor ax, ax
	
	mov ax, [bp + 8]	;moving day in ax
	shl ax, 7
	
	OR bx, ax
	
	xor ax, ax
	
	mov ax, [bp + 4]	;moving year in ax
	
	OR ax, bx
	
	pop bx
	pop bp
	
	ret 6
	
;this function will return day in ax, month in bx and year in cx
;after decoding the input
decode:
	
	;for keeping reference in stack
	push bp
	mov bp, sp
	
	;saving registers
	push di
	
	mov di, [bp + 4]	;moving input in ax
	mov cx, di
	
	AND cx, 0000000001111111b
	mov bx, di
	AND bx, 1111000000000000b
	shr bx, 12
	mov ax, di
	AND ax, 0000111110000000b
	shr ax, 7
	
	pop di
	pop bp
	
	ret 2

start:
	push word [day]
	push word [month]
	push word [year]
	
	call encode

	push ax
	call decode

finish:
	mov ax, 0x04c00
	int 21h