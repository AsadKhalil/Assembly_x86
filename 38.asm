[org 0x0100]

jmp start
n: dw 5
m: dw 4

binomial:
	push bp			
	mov bp, sp		
	sub sp, 2		
	push ax			
	push bx			
	push si			
	push dx
	push cx
	push di

	mov word[bp-2], 0	;initialize local variable to 0
	mov bx, [bp+4]		;address of input
	mov ax, [bp+6]
	
	cmp bx,1
	je true1
	cmp ax,0
    je true1
    cmp ax,bx
	je true1
	mov cx,ax
	mov si,bx
	dec cx
	dec si
	sub sp, 2	;space for return value
	push ax	;push address of input
	push si
	call binomial
    pop dx           	;call function
	sub sp, 2	;space for return value
	push cx	;push address of input
	push si
	call binomial
	pop di
	add dx,di
	jmp false1

	


true1:

	mov word[bp+8], 1	;moving binomial from ax to return value space
	jmp end1
	
false1:
	mov word[bp+8],dx
	
	
end1:
    pop di
    pop cx
	pop dx
	pop si			;restore value of si
	pop bx			;restore value of bx	
	pop ax			;restore value of ax
	add sp, 2		;removing local variable from memory
	pop bp			;restoring old value of bp
	ret 4		;removing parameters from stack 

start:
	sub sp, 2	;space for return value
	push word[m]	;push address of input
	push word[n]
	call binomial	;call function
	pop dx		;pop return value

mov ax, 0x4c00
int 21h

