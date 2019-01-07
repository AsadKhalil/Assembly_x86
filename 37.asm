[org 0x0100]

push _str
push substr2
call findSubstr

mov ax, 0x4c00
int 21h


findSubstr:
	push bp
	mov bp,sp

	push ax
	push bx
	push cx		
	push dx
	push si
	push di
	push es
	
	sub sp, 2
	push word [bp+4]
	call strlen
	pop dx
	
	sub sp, 2
	push word [bp+6]
	call strlen
	pop cx
	
	sub cx, dx
	add cx, 1
	cmp cx, 0
	jl not_found
	
	mov bx, [bp+4]
	mov al, [bx]

	mov bx, ds
	mov es, bx
	mov di, [bp+6]
	
_main:
	repne scasb
	cmp cx, 0
	je not_found
	push 0
	push di
	push word [bp+4]
	call confirm_found
	pop dx
	cmp dx, 1
	je found
	inc di
	dec cx
	jmp _main
	
found:
	push msg1
	jmp _end
	
not_found:
	push msg2
	
_end:
	call print
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	
	ret 4			;clear parameters
	
	
strlen:
	push bp
	mov bp,sp

	push ax
	push bx
	push cx		
	push dx
	push si
	push di
	push es
	
	mov cx, 0xffff
	mov ax, 0
	mov bx, ds
	mov es, bx
	mov di, [bp+4]
	repne scasb
	mov ax, 0xffff
	sub ax, cx
	mov [bp+6], ax
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	
	ret 2			;clear parameters
	

	
confirm_found:
	push bp
	mov bp,sp

	push ax
	push bx
	push cx		
	push dx
	push si
	push di
	push es
	
	sub sp, 2
	push word [bp+4]
	call strlen
	pop cx
	dec cx
	
	mov si, [bp+6]
	mov bx, ds
	mov es, bx
	mov di, [bp+4]
	inc di
	repe cmpsb
	cmp cx, 0
	jne __end
	mov word [bp+8], 1

__end:
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	
	ret 4			;clear parameters
	
print:
	push bp
	mov bp,sp

	push ax
	push bx
	push cx		
	push dx
	push si
	push di
	push es
	
	mov bx, 0xb800
	mov es, bx
	mov di, 0

	sub sp, 2
	push word [bp+4]
	call strlen
	pop cx
	dec cx

	cld
	mov si, 0
	mov ah, 0x07
	mov bx, [bp+4]
main_print:
	mov al, [bx+si]
	stosw
	inc si
	loop main_print

	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	
	ret 2			;clear parameters

_str: db 'Marry has a little lamb.',0
substr1: db 'lamb',0            ; findSubstr  prints “Substring Found.” for this substring.
substr2: db 'lame',0            ; findSubstr  prints “Substring Not Found.” for this substring.
msg1: db 'Substring Found.',0
msg2: db 'Substring Not Found.',0