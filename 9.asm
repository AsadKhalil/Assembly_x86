[org 0x0100]

jmp start

invertscr:
	mov ax, 0xb800	;moving video base in ax
	mov es, ax	;pointing es to video base
	mov di, 0	;pointing di to the top left coloumn
	
	mov cx, 0	;intializing cx with 0
	mov dx, 25	;total rows
	
outterloop:
	add cx, 160
	mov bx, 0	;for counting number of elements in stack
	
innerloop:
	mov ax, [es:di]
	push ax
	add di, 2 ;adding 2 in di to move to the next char
	inc bx ;updating number of elements in stack
	
	cmp di, cx	;has the whole line been added in the stack
	jnz innerloop
	
	mov ax, di
	sub ax, 160
	
	mov si, ax	;entering ending position of line in si
	
invert:
	;inverting the line
	pop ax
	mov [es: si], ax
	dec bx
	add si, 2
	cmp bx, 0
	jnz invert
	
	dec dx ;updating number of rows left to be inverted
	cmp dx, 0
	jnz outterloop
	
	ret

start:
	call invertscr
	
finish:
	mov ax, 0x04c00
	int 21h