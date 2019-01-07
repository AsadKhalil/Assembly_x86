[org 0x0100]

jmp start

message: db '*'

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


asterik:
	;saving registers
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	
	mov ax, 0xb800
	mov es, ax
	
	mov ax, 0
	
	;finding the left center of the screen
	mov al, 80
	mov bl, 12	;multiplying by ypos
	mul bl
	mov bl, 0	;adding xpos
	add al, bl
	shl ax, 1
	
	mov di, ax
	
	push ax ;moved the left center of the screen in the stack
	
	;finding the right center of the screen
	mov ax, 0
	mov dx, 0
	mov al, 80
	mov bl, 12
	mul bl	;multiplying by ypos
	mov bl, 80	;adding xpos
	add al, bl
	shl ax, 1
	
	mov si, ax
	
	;find the center of the screen
	mov ax, 0
	mov al, 80
	mov bl, 12
	mul bl
	mov bl, 40
	add al, bl
	shl ax, 1

	push ax	;moved the center of the screen in the stack
	
	push bp
	mov bp, sp
	
	mov al, [message]
	mov ah, 0x07
	mov bx, 0x0720
	
loop1:
	mov [es: di], ax

	mov [es:si], ax
	
	mov cx, 60000
	
	;jmp loop1
	
delay: loop delay	
	
	mov [es: di], bx
	mov [es: si], bx
		
	add di, 2
	sub si, 2
	
	cmp di, [bp + 2]
	jnz loop1
	
	sub di, 2
	add si, 2

loop2:
	mov [es: di], ax
	mov [es: si], ax
	
	mov cx, 60000
	
delay2: loop delay2

		
	mov [es: di], bx
	mov [es: si], bx

	
	sub di, 2
	add si, 2

	cmp di, [bp + 4]
	jnz loop2
	
	jmp loop1
	
	
	
start:
	call clearscr
	call asterik
	

finish:
	mov ax, 0x04c00
	int 21h