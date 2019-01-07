[org 0x0100]

jmp start 

;each queue has a size of 32 words = 64 bytes = 512 bits 
Queue: times 512 dw 0
flag: dw 0	;each bit of the flag is used to represent the state
				;of the corresponding flag
			
;=========================================			
;qcreate function returns the queue number
;if it finds a free queue or -1 if it
;failed. 

found:
	push word 1
	jmp endqfunc
	
notfound:
	push word -1
	jmp endqfunc

qcreate:
	push bp	;saving the value of bp
	mov bp, sp	;moving the value of sp into bp for having a reference in stack

	push ax	;saving thr value of ax
	push bx	;saving the value of bx
	push cx	;saving the value of cx
	
	mov bx, -64	;initializing bx with -64
	mov ax, 0	;initializing ax with 0
	mov cx, 0	;initializing cx with 0
	
loop1:
	add bx, 64
	mov ax, [Queue + bx + 62];rear
	
	cmp ax, 30
	jnz skipqc
	
	mov ax, 1
	jmp compare
	
skipqc:
	inc ax
	
compare:
	cmp ax, [Queue + bx]
	
	jnz found
	
	inc cx
	cmp cx, 15
	jz notfound
	jmp loop1
	
endqfunc:
	pop cx
	pop bx
	pop ax
	pop bp
	ret

;=========================================	
	

;=========================================	
;qdestroy marks the queue as free.
;It is assumed that by marking the queue
;free means that queue is reset to empty queue
;and the its corresponding value in flag variable
;is updated. It also takes Queue number as parameter.
qdestroy:
	push bp	;saving the value of bp
	mov bp, sp	;moving the value of sp into bp for having a reference in stack

	push ax	;saving thr value of ax
	push bx	;saving the value of bx
	push cx	;saving the value of cx
	push dx ;saving the value of dx
	
	;initializing registers
	mov ax, 64
	mov bx, 0
	mov cx, 0
	mov dx, 0
	
	;moving the parameter in bx register
	mov bx, [bp + 4]
	mul bx
	mov bx, ax
		
	
l1:	mov word [Queue + bx], 0
	add bx, 2

	inc cx
	cmp cx, 32
	jnz l1
	
	;updating the value of this queue in the flag variable
	mov ax, [flag]
	mov bx, [bp + 4] ;moving Queue number in bx
	mov cx, 1	;reseting cx register
	
	cmp cx, bx
	
l2:	rol ax, 1
	inc cx
	cmp cx, bx
	jb l2
	
skip1:
	sub dx, dx	;generating zero in the carry flag 

	rcr ax, 1
	
	mov cx, 1

	cmp cx, bx
	ja skip2
	
	
l3:	ror ax, 1
	inc cx
	cmp cx, bx
	jbe l3
	
skip2:

	mov word [flag], ax

	;ending function
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 2
	
;=========================================

;=========================================
;This function sets the specified bit of
;flag variable to 0.
setzero:
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx 
	
	mov ax, [flag]
	mov bx, [bp + 4]
	
	mov cx, 1	;reseting cx register
	
	cmp cx, bx
	;ja skip1b
	
l2c:
	rol ax, 1
	inc cx
	cmp cx, bx
	jb l2c
	
skip1b:
	mov dx, 5	
	sub dx, dx
	
	rcr ax, 1
	
	mov cx, 1

	cmp cx, bx
	ja skip2c
	
	
l3c:
	ror ax, 1
	inc cx
	cmp cx, bx
	jbe l3c
	
skip2c:

	mov word [flag], ax
	
	;ending function
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 2


;=========================================
;This function sets the specified bit of
;flag variable to 1.
setbit:
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx 
	
	mov ax, [flag]
	mov bx, [bp + 4]
	
	mov cx, 1	;reseting cx register
	
	cmp cx, bx
	ja skip1a
	
l2b:
	rol ax, 1
	inc cx
	cmp cx, bx
	jbe l2b
	
skip1a:
	mov dl, 5	
	mov dh, 10
	
	sub dl, dh
	
	rcr ax, 1
	
	mov cx, 1

	cmp cx, bx
	ja skip2b
	
	
l3b:
	ror ax, 1
	inc cx
	cmp cx, bx
	jbe l3b
	
skip2b:

	mov word [flag], ax
	
	;ending function
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 2
	
;=========================================
;This function returns 1 if insertion is
;possible other wise -1.
checkinpos:
	push bp
	mov bp, sp
	
	push ax
	
	mov ax, 0

	mov ax, [bp + 4]	;moving rear
	
	cmp ax, 30
	jz skipc
	
	inc ax
	jmp rempart
	
skipc:
	mov ax, 1	
	
rempart:
	cmp ax, [bp + 6]	;comparing it with front
	jz notpossible
	
	mov word [bp + 8], 1
	jmp endc
	
notpossible:
	mov word [bp + 8], -1

endc:
	pop ax
	pop bp
	ret 4 
;=========================================	

;=========================================	
;This function checks if qremove is possible
checkrempos:
	push bp
	mov bp, sp
	
	push ax
	
	mov ax, 0

	mov ax, [bp + 6]	;moving front
	
	cmp ax, 30
	jz skipd
	
	inc ax
	jmp rempart2

skipd:
	mov ax, 1

rempart2:
	cmp ax, [bp + 4]
	ja notpossible2
	
	mov word [bp + 8], 1
	jmp endd
	
notpossible2:
	mov word [bp + 8], -1

endd:
	pop ax
	pop bp
	ret 4 

;=========================================	
	
;=========================================	
;This function is used to remove items from
;the circular queue.
qremove:

	push bp	;saving the value of bp
	mov bp, sp	;moving the value of sp into bp for having a reference in stack

	push ax	;saving thr value of ax
	push bx	;saving the value of bx
	push cx	;saving the value of cx
	push dx ;saving the value of dx
	push si ;saving the value of si
	
	;initializing registers
	mov ax, 64
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov si, 0
	
	;moving queue number in bx register
	mov bx, [bp + 4]
	mul bx
	mov bx, ax

checkqr:
	sub sp, 2

	mov ax, [Queue + bx]	;Queue front
	push ax
	mov cx, ax
	mov ax, [Queue + bx + 62] ;Queue rear
	push ax
	
	call checkrempos
	
	pop dx
	
	cmp dx, 1
	jnz notapplicable2
	
	jmp applicable2
	
notapplicable2:
	mov word [bp + 6], 0
	jmp endrem
	
applicable2:
	mov word [bp + 6], 1
	
	mov ax, [Queue + bx]
	
	mov si, 2
	mul si
	
	mov si, ax
	
	mov word [Queue + bx + si], 0
	
	mov word ax, [Queue + bx]
	
	cmp ax, 30
	jnz skipq

	mov ax, 1
	jmp placefront
	
skipq:
	inc ax
	
placefront:
	mov [Queue + bx], ax

checkifreset:
	cmp cx, [Queue + bx + 62]
	jnz endrem
	
	mov word[Queue + bx], 0
	mov word[Queue + bx + 62], 0
	
	push word [bp + 4]
	
	call setzero
	
endrem:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 2
;=========================================	
	
;=========================================
;This function is used to add items in the
;circular queue. A real circular queue is
;dynamic but according to this question
;the circular queue is static.
qadd:
	push bp	;saving the value of bp
	mov bp, sp	;moving the value of sp into bp for having a reference in stack

	push ax	;saving thr value of ax
	push bx	;saving the value of bx
	push cx	;saving the value of cx
	push dx ;saving the value of dx
	push si ;saving the value of si
	
	;initializing registers
	mov ax, 64
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov si, 0
	
	;moving queue number in bx register
	mov bx, [bp + 4]
	mul bx
	mov bx, ax

check1:
	sub sp, 2

	mov ax, [Queue + bx]
	push ax
	
	mov	ax, [Queue + bx + 62]
	push ax

	call checkinpos
	
	pop dx
	cmp dx, 1
	jz applicable
	
notapplicable:
	mov word [bp + 8], 0
	jmp endaddfunc

skipb:
	mov ax, 1
	jmp skipad
	
applicable:
	cmp word [Queue + bx + 62], 1
	jnz skip4d
	
	cmp word [Queue + bx], 1
	jnz skip4d
	
	push word [bp + 4]
	call setbit

skip4d:
	mov ax, [Queue + bx + 62]
	cmp ax, 30
	jz skipb
	
	inc ax
	
	
skipad:
	mov word [Queue + bx + 62], ax
	
	mov si, 2
	mul si
	
	mov si, ax
	
	mov ax, [bp + 6]	;moving data parameter in ax
	mov word [Queue + bx + si], ax
	
	mov word [bp + 8], 1
	
	mov ax, [Queue + bx]
	
	cmp ax, 0
	jnz endaddfunc
	
	inc ax
	mov [Queue + bx], ax
	
endaddfunc:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 4

;=========================================
	
	
start:
	sub sp, 2
	call qcreate
	pop dx
	
	mov ax, 2
	push ax
	
	call qdestroy
	
	sub sp, 2
	mov ax, 0xA	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xB	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xC	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xD	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xE	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xF	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	sub sp, 2
	call qcreate
	pop dx
	
	mov ax, 0xAA	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xAB	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xAC ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xAD	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xAE	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xAF ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xBA	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xBB	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xBC ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	
	mov ax, 0xBD	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xBE	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xBF ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
		
	mov ax, 0xCA	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xCB	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xCC ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xCD	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xCE	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xCF ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xDA	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xDB	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xDC ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xDD	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xDE	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
	mov ax, 0xDF ;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0xEA	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	sub sp, 2
	call qcreate
	pop dx
	
	call qadd
	
	push word 0
	call qremove
	
	
	push word 0
	call qremove
	
	
	push word 0
	call qremove
	
	mov ax, 0x11	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	mov ax, 0x33	;item to add
	push ax
	mov ax, 0	;queue number
	push ax
	
	call qadd
	
	
finish:
	mov ax, 0x04c00
	int 21h