[org 0x0100]

jmp start

flag: db 0

;single step interrupt service routine
trapisr:
	;for keeping a reference in stack
	push bp
	mov bp, sp
	
	;saving all registers
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	push ds
	
	push cs
	pop ds
	
	sti	;set interrupt flag

	push cs
	pop ds
	
	mov byte [flag], 0
	
	
	pop ds
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	
	iret
	
start:
	mov ax, 0
	mov es, ax
	
	mov [es: 1 * 4], trapisr
	mov [es: 1* 4 + 2], cs
	
	