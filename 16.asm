[org 0x0100]

jmp start

oldkb:	dd 0
; subroutine to print a number at the specificed location of the screen
; order of parameters: location, number
printnum:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di
	
	mov ax, 0xb800
	mov es, ax ; point es to video base
	
	mov ax, [bp+4] ; load number in ax
	mov di, [bp + 6] ; pointing di to the specified location
	
	mov bx, 16 ; use base 10 for division
	
nextdigit: 
	mov dx, 0 ; zero upper half of dividend
	div bx ; divide by 10
	add dl, 0x30 ; convert digit into ascii value
	
	mov dh, 0x07
	mov [es:di], dx
	
	sub di, 2
	cmp ax, 0 ; is the quotient zero
	jnz nextdigit ; if no divide it again

	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 4
	
;/////////////////////////////////////////////////////////////////////////////////////////////////////
;keyboard interrupt serivce routine
kbisr:
	;saving register
	push ax
	push bx
	
	mov ax, 0xb800
	mov es, ax
	
	in al, 0x60	;read char from keyboard port
	cmp al, 0x43;check if F9 key was pressed
	jz displaysec	;if pressed jump to displaysec
	
	cmp al, 0x44;check if F10 key was pressed
	jz displaymin 	;if pressed jump tp displaymin
	
	cmp al, 0x57;check if F11 key was pressed
	jz displayhour	;if pressed jump to displayhour
	
	cmp al, 0x58;check if F12 key was pressed
	jz displaytimelabel	;if pressed jump to displaytime
	
	jmp exitlabel	;jump to exit label if no key matched then jump to exit
	
displaysec:
	mov al, 00	;moving command byte in al
	out 0x70, al	;writing command byte at port 0x70
	jmp skip1	;waste on instruction time
	
skip1:	
	xor ax, ax
	in al, 0x71	;result of command is in al
	mov bx, 158
	
	push bx
	push ax
	call printnum
	
	in ax, 0x60
	cmp al, 11000011b	;check if the key has been released
	jnz displaysec ;if not then keep displaying sec
	
	;if the key has been released then clear the coloumn
	mov word [es: 156], 0x720
	mov word [es: 158], 0x720
	jmp exit

exitlabel:
	jmp exit
	
displaymin:
	mov al, 02
	out 0x70, al	;writing command byte at port 0x70
	jmp skip2	;waste on instruction time
	
skip2:	
	xor ax, ax
	in al, 0x71	;result of command is in al
	mov bx, 158
	
	push bx
	push ax
	call printnum
	
	in ax, 0x60
	cmp al, 11000100b	;check if the key has been released
	jnz displaymin ;if not then keep displaying sec
	
	;if the key has been released then clear the coloumn
	mov word [es: 156], 0x720
	mov word [es: 158], 0x720
	jmp exit

displaytimelabel:
	jmp displaytime
	
displayhour:
	mov al, 04
	out 0x70, al	;writing command byte at port 0x70
	jmp skip3	;waste on instruction time
	
skip3:	
	xor ax, ax
	in al, 0x71	;result of command is in al
	mov bx, 158
	
	push bx
	push ax
	call printnum
	
	in ax, 0x60
	cmp al, 11010111b	;check if the key has been released
	jnz displayhour ;if not then keep displaying sec
	
	;if the key has been released then clear the coloumn
	mov word [es: 156], 0x720
	mov word [es: 158], 0x720
	jmp exit	
	
displaytime:
	mov al, 00	;moving command byte in al
	out 0x70, al	;writing command byte at port 0x70
	
	xor ax, ax
	in al, 0x71	;result of command is in al
	
	mov bx, 158
	push bx
	push ax
	call printnum
	
	mov word [es: 154], 0x73A
	
	mov al, 02	;moving command byte in al
	out 0x70, al	;writing command byte at port 0x70
	
	xor ax, ax
	in al, 0x71	;result of command is in al
	
	mov bx, 152
	push bx
	
	push ax
	call printnum
	
	
	mov word [es: 148], 0x73A
	
	mov al, 04	;moving command byte in al
	out 0x70, al	;writing command byte at port 0x70
	
	xor ax, ax
	in al, 0x71	;result of command is in al
	
	mov bx, 146
	
	push bx
	push ax
	call printnum
	
	in al, 0x60
	cmp al, 11011000b
	jnz displaytime
	
	;clear the portion of the screen
	mov word [es: 144], 0x720
	mov word [es: 146], 0x720
	mov word [es: 148], 0x720
	mov word [es: 150], 0x720
	mov word [es: 152], 0x720
	mov word [es: 154], 0x720
	mov word [es: 156], 0x720
	mov word [es: 158], 0x720
	
exit:
	;chaning has been used here so that the keyboard will work like normal
	pop bx
	pop ax
	jmp far [cs: oldkb]
	

;/////////////////////////////////////////////////////////////////////////////////////////////////////


start:
	xor ax, ax
	mov es, ax ; point es to IVT base
	
	mov ax, [es:9*4]
	mov [oldkb], ax ; save offset of old routine
	mov ax, [es:9*4+2]
	mov [oldkb+2], ax ; save segment of old routine

	cli ; disable interrupts
	mov word [es:9*4], kbisr ; store offset at n*4
	mov [es:9*4+2], cs ; store segment at n*4+2
	sti ; enable interrupts

	mov dx, start ; end of resident portion
	add dx, 15 ; round up to next para
	mov cl, 4
	shr dx, cl ; number of paras
	
	mov ax, 0x3100 ;terminate and stay resident
	int 21h