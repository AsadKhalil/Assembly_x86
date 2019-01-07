[org 0x0100]

jmp start

gcd:
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	
	mov ax, [bp + 6]	;ax contains num1
	mov bx, [bp + 4]	;bx contains num2
	
	cmp ax, bx
	jz basecase
	
	cmp ax, bx
	jb skip
	
	mov cx, ax
	sub cx, bx
	
	sub sp, 2
	push cx
	push bx
	
	call gcd
	
	pop dx
	
	mov [bp + 8], dx
	
	jmp exit
	
skip:
	mov cx, ax
	sub bx, cx
	push ax
	push bx
	
	call gcd
	
	pop dx
	
	mov [bp + 8], dx
	
	
	jmp exit

basecase:
	mov [bp + 8], ax
	
exit:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 4

start:
	sub sp, 2
	mov ax, 10
	push ax
	
	mov ax, 5
	push ax
	
	call gcd
	
	pop dx
	
finish:
	mov ax, 0x04c00
	int 21h