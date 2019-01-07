[org 0x0100]

;This subroutine finds if a set of consecutive n number of zeros is present in the given sequence or not

;Name: Asad Raheem
;Roll Number: 13L-4233
;Section: A

jmp start

sequence: times 32 db 01001111b, 01010101b, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

foundbit:
	inc ch
	cmp ch, dl
	jz foundset
	
	cmp bx, 32
	jz noset
	
	cmp cl, 8
	jnz checkbyte
	
	inc bx
	jmp loop1
	
	

foundset:
	sub si, dx
	inc si
	mov word [bp + 6], si
	jmp endoffunc
	
noset:
	mov ax, -1
	mov word [bp + 6], ax
	jmp endoffunc
	
findConsecutiveZeros:
	push bp
	mov bp, sp			;for having a reference point
	
	push ax				;saving value of ax in stack
						;ah stores the byte
						;al stores the bit number
	push bx				;saving value of cx in stack
	push cx	
	push dx
	push si
	
	mov ax, 0
	mov si, 254			;stored zero bit number
	mov bx, 0			;initializing bx with zero
	mov cx, 0
	mov dx, 0
	
	mov dl, [bp + 4]	;storing the parameter inside the register
	
loop1:
	mov ah, [sequence + bx]
	mov cl, 0				;reset cl - cl contains the local(used this word for my own reference) bit number
	
checkbyte:

	inc si
	inc cl
	
	shl ah, 1
	jnc foundbit
	
	mov ch, 0	;reset ch if 0 not found
	
	cmp cl, 8
	jnz checkbyte
	
	cmp bx, 32
	jz noset
	
	inc bx
	jmp loop1
	
endoffunc:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret

start:
	mov ax, 3	;moving number of zeros to find into ax
	sub sp, 2
	push ax
	call findConsecutiveZeros
	pop ax
	
	pop dx ;dx contains the result

finish:
	mov ax, 0x04c00
	int 21h