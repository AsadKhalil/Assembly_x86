[org 0x0100]

jmp start

message: db 'hello_word'

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

printnum:	
	;parameters order of pushing
	;x pos, ypos, attribute, number, base
	
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	push di
	push es
	
	mov ax, 0xb800
	mov  es, ax	;pointing es to video base
	
	mov ax, [bp + 6] ;loading number in ax
	mov bx, [bp + 4]	;moving base in bx for division
	mov cx, 0	;intialize count of digits
	
nextdigit:
	mov dx, 0	;zero upper half of dividend
	div bx	;divide by bx
	add dl, 0x30	;convert digit into ASCII value
	push dx	;save ASCII value on stack
	inc cx	;incrememnt count of values
	cmp ax, 0	;is the quotient zero
	
	jnz nextdigit	;if no divide it again
	
	mov ax,  0xb800
	mov es, ax	;pointing es to video base
	
	mov al, 80 ;load al with coloumns per row
	mul byte [bp+ 10] ;multiplying with ypos
	add ax, [bp + 12] ;adding xpos
	shl ax, 1 ;turn into byte offset by multiplying by 2
	mov di, ax	;moving ax to di to point di to the required location
	
keepprintnum:
	pop dx
	mov dh, [bp + 8]
	mov [es:di], dx
	add di, 2
	loop keepprintnum
	
	pop es
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 10
	
start:
	mov ax, 40	;xpos
	push ax
	mov ax, 12	;ypos
	push ax

	mov ax, 0x07 ;attribute
	push ax

	mov ax, message	;string/number
	push ax

	mov ax, 10	;size/base
	push ax

	call printstr
	
	
finish:
	mov ax, 0x04c00
	int 21h