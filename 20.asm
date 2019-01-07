[org 0x0100]

jmp start

string: db 0

printstr:
	;parameters order of pushing
	;x pos, ypos, attribute, message, length
	
	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push cx
	push di
	push si
	push es
	
	mov ax, 0xb800
	mov es, ax	;point es to video base
	mov al, 80	;load al with coloumns per row
	mul byte [bp + 10]	;multiplying with ypos
	add ax, [bp + 12]	;adding x pos
	shl ax, 1	;turn into byte offset by multiplying by 2
	
	mov di, ax	;moving ax to di to point di to the required location
	mov si, [bp + 6]	;pointing si to the parameter string
	mov cx, [bp + 4]	;moving parameter length into cx
	mov ah, [bp + 8]	;moving parameter attribute into ah
	
keepprintstr:
	mov al, [si]	;moving current char of string into al
						;a char is the size of a byte
	mov [es:di], ax	;moving the char(al) with the attribute(ah) in video memory
	add di, 2	;moving di to the next location in the video memory
	add si, 1	;moving si to the next char
	
	loop keepprintstr	;repeat the loop cx times
	
	pop es
	pop si
	pop di
	pop cx
	pop ax
	pop bp

	;there are 5 parameters so ret 10
	ret 10


clearscr:
	push ax
	push cx
	push es
	push di
	
	mov ax, 0xb800
	mov es, ax	;pointing es to video base
	xor di, di	;setting di to 0
	mov ax, 0x0720	;loading ax with space character in normal attribute
	mov cx, 2000	;loading cx with number of screen locations
	
	cld	;auto-increment mode
	
	rep stosw	;clear the whole screen
						;stows takes the data from ax and stores it in destination location [es:di] 
	pop di
	pop es
	pop cx
	pop ax

	ret

start:
	mov ah, 0x10	;service 10 - vga attribute
	mov al, 3	;subservice 3	- toggle blinking
	mov bl, 1	;enable blinking bit
	int 0x10	;call BIOS video serivce

	call clearscr
	mov bx, string
	mov cx, 0
l1:
	mov ah, 0	;service 0 - get keystroke
	int 0x16	;call BIOS keyboard service
	mov [bx], al
	inc bx
	inc cx
	cmp al, 0+*
	jnz l1
	
	mov ax, 0
	push ax
	push ax
	mov ax, 0x71
	push ax
	mov ax, string
	push ax
	push cx
	call printstr
	
finish:
	mov ax, 0x04c00
	int 21h