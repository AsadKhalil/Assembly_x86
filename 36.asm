[org 0x0100]

jmp start

scrollup:
;this function takes the number of lines to be scrolled up as a parameter

	;for keeping reference in stack
	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push cx
	push si
	push di
	push es
	push ds
	
	mov ax, 80	;loading number of chars per row
	mul byte [bp + 4] ;multiplying by number of lines to be scrolled up
	
	;now ax contains the number of line where scrolling should be started towards above
	
	mov si, ax	;moving the number of line where scrolling should be statred towards above in si
	push si	;saving si for later use
	
	shl si, 1	;turning into byte offset
	
	;now si contains the location of the starting line from which the screen should be scrolled above
	
	mov cx, 2000	;loading cx with total number of screen location
	sub cx, ax	;calculating number of words to move
	
	mov ax, 0xb800
	
	;pointing es and ds to video base
	mov es, ax
	mov ds, ax

	xor di, di	;setting di to 0 to point it to the top left coloumn of the screen

	cld	;auto increment
	
	rep movsw	;mov chars from source to destination. Source should be below and destination should be above.

	mov ax, 0x0720
	pop cx	;count of positions to clear
	rep stosw	;cleared the scrolled space
	
	pop ds
	pop es
	pop di
	pop si
	pop cx
	pop ax
	pop bp
	
	ret 2
	
start:
	mov ax, 5
	push ax
	call scrollup
	
finish:
	mov ax, 0x04c00
	int 21h