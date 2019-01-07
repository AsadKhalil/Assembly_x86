[org 0x0100]

jmp start

fib:
	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push bx
	push cx
	push dx
	
	mov ax, [bp + 4]  ;moving number in ax
	
	cmp ax, 0
	jz basecase1
	
	cmp ax, 1
	jz basecase2
	
	sub ax, 1
	sub sp, 2
	
	push ax
	call fib
	
	pop cx
	
	sub ax, 1
	sub sp, 2
	
	push ax
	call fib
	
	pop dx
	
	add cx, dx
	
	mov [bp + 6], cx
	jmp exit
	
basecase1:
	mov word [bp + 6], 0
	jmp exit

basecase2:
	mov word [bp + 6], 1

exit:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 2


start:
	sub sp, 2
	mov ax, 6
	push ax
	call fib
	
	pop dx
finish:
	mov ax, 0x04c00
	int 21h