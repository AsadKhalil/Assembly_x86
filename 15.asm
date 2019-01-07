[org 0x0100]

jmp start


keypress: dW 0
count: dw 0
oldkb:	dd 0
seconds: dw 0

;keyboard interrupt service routine
kbisr:
	push ax

	in al, 0x60	;read char from keyboard port
	
	cmp al, 0x10   ; key q
	jae check2

	jmp notfound

check2:
	cmp al, 0x19
	jbe pressed

	cmp al, 0x1E
	jae check3

	jmp notfound

check3:
	cmp al, 0x26
	jbe pressed

	cmp al, 0x2C
	jae check4

	jmp notfound

check4:
	cmp al, 0x32
	jbe pressed

	jmp notfound

pressed:
	mov word [cs: keypress], 1
	jmp exit

notfound:
	mov word [cs: keypress], 0

	pop ax
	jmp far [cs: oldkb]	;call original isr

exit:
	;sending end of interrupt signal
	mov al, 0x20
	out 0x20, al	;send EOI to PIC

	pop ax
	iret



;timer interrupt service routine
timer:
	push ax
	push bx
	push cx
	push es

	mov ax, 0xb800
	mov es, ax

	;events to took every time the timer interrupt occurs
	inc word [cs:seconds]
	
	cmp word [cs:keypress], 0
	jz notpressed
	
	inc word [cs:count]
	mov word [cs:keypress], 0

notpressed:
	;check if 5 second circle has been completed
	cmp word [cs:seconds], 91
	jb exit2

	;clearing loop
	mov bx, 158
	mov cx, 24
loop1:
	mov word [es: bx], 0x720
	add bx, 160
	dec cx
	cmp cx, 0
	jnz loop1

	mov bx, 158
	mov cx, [cs:count]

	cmp word [cs:count], 0
	jz exit2
loop2:
	mov word [es: bx], 0x72a
	dec cx
	cmp cx, 0
	jnz loop2

	mov word [cs:count], 0
	mov word [cs:seconds], 0
	
exit2:
	mov al, 0x20
	out 0x20, al

	pop es
	pop cx
	pop bx
	pop ax
	iret

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

	mov word [es:8*4], timer ; store offset at n*4
	mov [es:8*4+2], cs ; store segment at n*4+
	sti ; enable interrupts
	mov dx, start ; end of resident portion
	add dx, 15 ; round up to next para
	mov cl, 4
	shr dx, cl ; number of paras
	mov ax, 0x3100 ; terminate and stay resident
	int 0x21