[org 0x0100]

jmp start

gcd:

	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	
	mov bx, [bp + 4]
	mov ax, [bp + 6]
	
	cmp ax, 0
	jz basecase
	
	sub sp, 2
	mov cx, ax	;cx now contains ax
	mov ax, bx	;ax now contains bx
	div cx
	
	push dx	;pushing the remainder
	push cx	;pushing a
	
	call gcd
	
	jmp exit
	
basecase:
	mov word [bp + 6],  bx
	
exit:

	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 4
	
	
start:
	sub sp, 2
	
	mov ax, 4
	push ax
	mov ax, 2
	push ax
	call gcd

finish:
	mov ax, 0x04c00
	int 21h