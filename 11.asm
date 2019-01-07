[org 0x0100]

jmp start

swapscr:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0
	mov cx,80
	
	mov ax, 0
	mov al, 80
	mov bl, 12	;ypos
	mul bl
	mov bx, 40	;xpos
	add ax, bx
	shl ax, 1
	
	mov si, ax
	
loop1:
	mov ax, [es: di]
	mov bx, [es: si]
	
	mov [es:di], bx
	mov [es:si], ax
	
	add si, 2
	add di, 2
	cmp di, cx	;checking if the first line has been swapped
	jnz loop1
	
	add si, 80
	add di, 80
	add cx, 160
	
	cmp cx, 2160
	jnz loop1
	
	ret

start:
	call swapscr
	
finish:
	mov ax, 0x04c00
	int 21h