[org 0x100]

jmp start

scrolldown:
;takes the number of lines to be scrolldown

	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push cx
	push si
	push di
	push ds
	push es
	
	mov ax, 80	;number of characters per row
	mul byte [bp + 4]	;mulitiplying by number of lines
	
	push ax	;savng number of lines for later use
	
	shl ax, 1	;turning into byte offset
	
	mov si, 3998	;moving last location of screen
	
	sub si, ax	;calculating source position in ax
	
	mov cx, 2000	;moving number of locations
	
	sub cx, ax	;count of words to move
	
	mov ax, 0xb800
	mov es, ax
	mov ds, ax
	
	mov di, 3998	;point di to lower right coloumn
	
	std ;set auto decrement mode
	
	rep movsw
	
	mov ax, 0x720
	
	pop cx
	
	rep stosw
	
	pop es
	pop ds
	pop di
	pop si
	pop cx
	pop ax
	pop bp
	
	ret 2

start:
		mov ax, 5
		push ax
		
		call scrolldown
		
finish:
		mov ax, 0x4c00
		int 21h