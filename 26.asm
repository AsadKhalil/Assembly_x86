[org 0x0100]

jmp start

factorial:
	push bp
	mov bp, sp

	cmp word[bp + 4], 1
	jZ basecase

	sub sp, 2
	mov ax, word[bp + 4]

	sub ax, 1
	push ax

	call factorial
	
	pop bx
	mov ax, word[bp + 4]
	mul bl
	mov word[bp + 6], ax
	jmp endfunc

basecase:
	mov word[bp + 6], 1

endfunc:
	pop bp
	ret 2	

start: mov ax, 4
	sub sp, 2
	
	push ax
	call factorial
	pop dx	


finish: mov ax, 0x04c00
	int 21h


