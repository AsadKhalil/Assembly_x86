[org 0x0100]

jmp start

mystr: db 'T', 'h', 'i', 's', 'W', 'o', 'r', 'd'
sizes:	db $ - mystr
reserved: db 0

temp1: db 0
temp2: db 0

P1: dw 0	;direction of rotation	- 0 for left & 1 for right
P2: dw 1	;number of rotation

scrollup:	push bp
			mov bp, sp
			push ax
			push cx
			push si
			push di
			push es
			push ds
			push cs
			
			
			push ds
			pop es
			mov di, buffer
			
			mov ax, 0xb800
			mov ds, ax
			mov si, 0
			mov cx, 80
			
			cld
			rep movsw
			
			push es
			
			mov ax, 0xb800
			mov ds, ax
			mov es, ax
			mov si, 160
			mov di, 0
			
			mov cx, 1920
			
			cld
			rep movsw
			
			pop ds
			mov si, buffer
			mov di, 3840
			mov cx, 80
			
			cld
			rep movsw
			
			pop cs
			pop ds
			pop es
			pop di
			pop si
			pop cx
			pop ax
			pop bp
			ret
			
timer:		push ax
			
			cmp word [cs:timerFlag], 1
			jne skip
			
			call scrollup
			
		
;;;;;
;;;;signaling eoi

	skip:	mov al, 0x20
		out 0x20, al
			
			pop ax
			iret
			
			
kbisr:		push ax
			
			in al, 0x60
			cmp al, 0x44									;check if f10 is pressed
			jne checkReleased
			
			cmp word [timerFlag], 1
			je exit
			
			mov word [timerFlag], 1
			jmp exit

checkReleased:	cmp al, 0xc4					;check if f10 is released
				jne otherKey
				
				mov word [timerFlag], 0
				jmp exit
				
otherKey:	pop ax
			jmp far [cs:oldkb]
			
exit:		mov al, 0x20
			out 0x20, al
			
			pop ax
			iret

rotate:
	mov ax, [sizes]
	
	mov bx, 2
	div bx
	
	mov bx, 0
	
	pop bx
	
	pop cx	;number of rotation
	pop dx 	;direction of rotation
	
	push bx
	
	push dx
	push cx
	
	mov word [temp1], cx ;saving cx
	
	mov si, ax
	dec si
	
	cmp dx, 0
	;ja loop2
	
;left rotating	
loop1aint:
	mov bh, [mystr]
	mov byte[reserved], bh
	
	mov bh, [mystr + si]
	
loop1a:
	mov bl, bh
	mov bh, [mystr + si - 1]
	mov [mystr + si - 1], bl
	dec si
	cmp si, 0
	jnz loop1a
	jmp loop1aend
	
loop1aend:
	mov si, ax
	dec si
	mov bl, [reserved] 
	mov byte [mystr + si], bl
	
	dec cx
	cmp cx, 0
	jnz loop1aint
	
loop1bint:
	mov si, ax
	mov bh, [mystr + si + 1]
	mov byte[reserved], bh

	mov dx, 2
	mul dx
	mov si, ax
	dec si
	mov bh, [mystr + si]
	
	pop cx
	pop dx
	
loop1b:
	mov bl, bh
	mov bh, [mystr + si - 1]
	mov [mystr + si - 1], bl
	dec si
	cmp si, ax
	jnz loop1b
	jmp loop1bend
	

loop1bend:
	div dx
	mov bl, [reserved] 
	mov byte [mystr + si], bl
	
	dec cx
	cmp cx, 0
	jnz loop1bint
	jmp start
	
	
	
	

	

start:
xor ax, ax
			mov es, ax
			mov ax, [es:9*4]
			mov [oldkb], ax
			mov ax, [es:9*4+2]
			mov [oldkb+2], ax
			mov bx, buffer
			
			
			cli
			mov word [es:9*4], kbisr
			mov [es:9*4+2], cs
			
			mov word [es:8*4], timer
			mov [es:8*4+2], cs
			sti
			
			mov dx, start
			add dx, 15
			mov cl, 4
			shr dx, cl
			mov ax, 0x3100
			int 21h
;;;;
;mov cx, 0
	;mov bx, [P1]
	;push bx
	
	;mov bx, [P2]
	;push bx
	
	;call rotate

finish:
	mov ax, 0x04c00
	int 21h