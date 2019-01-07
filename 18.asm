[org 0x0100]

jmp start

oldisr:	dd 0

kbisr:
;Keyboard Interrupt Service Routine(ISR)

	push ax
	push es
	
	mov ax, 0xb800
	mov es, ax
	
	in al, 0x60	;read the scan code from port 0x60
	cmp al, 0x2a	;check if left shift key was pressed
	jne nextcmp
	
	mov byte [es: 0], 'L'
	
	jmp nomatch
	
nextcmp:
	cmp al, 0x36
	jne nomatch
	mov byte [es: 0], 'R'
	
nomatch:
	;sending end of interrupt signal
	mov al, 0x20
	out 0x20, al
	
	pop es
	pop ax
	
	iret

start:
	xor ax, ax
	mov es, ax	;pointing es to vector the start of vector table
	
	;disabling all interrupts
	cli	;clear the interrupt flag
	mov word [es: 9 * 4], kbisr	;moving offest of kbisr to the vector table's 9th interrupt offset
	mov [es: 9 * 4 + 2], cs	;moving segment of kbisr which is the code segment to the vector table's 9th interrupt segment
	;enabing all interrupts
	sti	;set the interrupt flag
	
	
l1:	jmp l1	;start an infinite loop