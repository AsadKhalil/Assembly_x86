[org 0x0100]

jmp start

flip:
	xor si, si
	mov ax, 0
	mov al, 80
	mov bl, 24
	mul bl
	add ax, 79
	mov di, ax
	shl di, 1
	
	mov ax, 0xb800
	mov es, ax
	mov ds, ax
	
	mov ax, 80
	mov bl, 12
	mul bl
	add ax, 39
	mov bx, ax
	mov cx, bx
	shl bx, 1
xor ax, ax
loop1:
	cld
	lodsw
	
	std
	stosw
	
	loop loop1
	
	ret
	
start:
	call flip
	
finish:
	mov ax, 0x04c00
	int 21h