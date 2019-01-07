[org 0x0100]

jmp start

mainstr: db	'Mary has a lamb', 0
substr: db 'has', 0

;this function is used calculate the length of the string
strlen:
;order of pushing parameters: segment and offset
;length is returned in ax

	;for keeping reference in stack
	push bp
	mov bp, sp
	
	;saving registers
	push cx
	push di
	push es
	
	les di, [bp + 4]	;this will load di with message offset at [bp + 4] and es with segment stored at [bp + 6]
	
	mov cx, 0xFFFF	;loading maximum number in cx
	xor al, al	;loading a zero in al
	
	repne scasb	;search for zero
	
	mov ax, 0xFFFF
	sub ax, cx
	dec ax
	
	pop es
	pop di
	pop cx
	pop bp
	ret 4


;This function is used to tell if a substring exists in
;the main string. It returns the index of the first position
;where the substrfind is found otherwise returns -1.
substrfind:
;order of parameters: address of main string, address of sub-string
	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push bx
	push cx
	push di
	push si
	push es
	
	push ds
	pop es
	
	;finding length of main string
	push ds
	push word [bp + 6]
	call strlen
	
	mov cx, ax	;saving length if main string in cx
	
	;finding length of sub string
	push ds
	push word [bp + 4]
	call strlen
	
	cmp cx, ax	;if main string size is less than substring then string not found.
	jb notfound
	
	mov bx, cx	;saving total length of ax for lateruse
	
	;because cmps subtracts the source [ds: si] from destination [es: si]
	mov di, [bp + 6]	;loading address of main string
	mov si, [bp + 4]	;loading address of sub string
	
cmploop:
	repe cmpsb	;compares main string [ds:si] with [es:di]
	je found

	sub si, 2
	cmp cx, 0
	jnz cmploop
		
	sub bx, cx
	
	mov [bp + 8], bx
	jmp exit
	
notfound:
	mov word [bp + 8], -1
	
exit:
	pop es
	pop si
	pop di
	pop cx
	pop ax
	pop bx
	pop bp
	
	ret 4
	
start:
	sub sp, 2
	mov ax, mainstr
	push ax	;pushing address of main string
	
	mov ax, substr
	push ax	;pushing address of sub string
	
	call substrfind

finish:
	mov ax, 0x04c00
	int 21h
