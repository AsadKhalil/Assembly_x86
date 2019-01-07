[org 0x0100]

clearscr:

	;saving registers
	push ax
	push es
	push di
	
	mov ax, 0xb800	;loading video base in ax
	mov es, ax	;pointing es to video base
	mov di, 0	;pointing di to the top of the left coloumn of the screen
	
keepclear:
	mov word [es: di], 0x0720
	add di, 2
	cmp di, 4000
	jne keepclear

	pop di
	pop es
	pop ax
	
	ret

start:
	call clearscr

finish:
	mov ax, 0x04c00
	int 21h