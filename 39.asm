[org 0x0100]

jmp start
input: dw 6






prime:
	push bp			
	mov bp, sp		
	sub sp, 2		
	push ax			
	push bx		
    push cx	
	push dx

	mov word[bp-2], 0	
	mov bx, [bp+4]		
    mov cx,bx
	
	loop1:
	mov dx,0
	mov ax,cx
    dec bx
	cmp bx,1 
	je true1
	div bx
	cmp dx,0 
	je false1
	jmp loop1
	

	


true1:

	mov word[bp+6], 1	;moving prime from ax to return value space
	jmp end1
	
false1:
	mov word[bp+6],0
	
end1:

	pop dx
	pop cx		;restore value of si
	pop bx			;restore value of bx	
	pop ax			;restore value of ax
	add sp, 2		;removing local variable from memory
	pop bp			;restoring old value of bp
	ret 2		;removing parameters from stack 
	
	
	
	
adjacent:
	push bp			
	mov bp, sp		
	sub sp, 2			
	push bx				
	push dx

	mov word[bp-2], 0	;initialize local variable to 0
	mov bx, [bp+4]		;address of input
    
	loop2:
    dec bx
	sub sp, 2	;space for return value
	push bx  	;push address of input
	call prime	;call function
	pop dx		;pop return value
	cmp dx,0
	je loop2
	
	mov [bp+6],bx
	
end2:

	pop dx
	pop bx			;restore value of bx	
	add sp, 2		;removing local variable from memory
	pop bp			;restoring old value of bp
	ret 2		;removing parameters from stack 
	

start:
	sub sp, 2	;space for return value
	push word[input]	;push address of input
	call prime	;call function
	pop dx		;pop return value
	cmp dx,0
	je exit1
	
	sub sp, 2	;space for return value
	push word[input]
	call adjacent
	pop dx

	
exit1:
	mov ax, 0x4c00
	int 21h
