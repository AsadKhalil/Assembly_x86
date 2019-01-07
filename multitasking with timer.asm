;multitasking
; to display running counters such that  with each keystroke a counter starts from 00:00:00 while all the previous counters are running
org 0x100
	jmp start
oldisr:dd 0

jmp start
; PCB layout:
; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30
pcb: times 32*16 dw 0 ; space for 32 PCBs
stack: times 32*256 dw 0 ; space for 32 512 byte stacks
nextpcb: dw 1 ; index of next free pcb
current: dw 0 ; index of current pcb
lineno: dw 0 ; line number for next thread
counter: times 96 db 0
; mytask subroutine to be run as a thread
; takes line number as parameter

mytask: push bp
	mov bp, sp
;	sub sp, 2 ; thread local variable
	push ax
	push bx
	mov ax, [bp+4] ; load line number parameter
	mov bx, 0x60 ; use column number 96
	;mov word [bp-2], 0 ; initialize local variable

printagain: push ax ; line number
;	push bx ; column number
;	push word [bp-2] ; number to be printed
	jmp key
bk:	call print ; print the number
	;inc word [bp-2] ; increment the local variable
	;pop ax
	
	jmp printagain ; infinitely print
	pop bx
	pop ax

	mov sp, bp
	pop bp
	ret
; subroutine to register a new thread
; takes the segment, offset, of the thread routine and a parameter
; for the target thread subroutine
initpcb: push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push si
	mov bx, [nextpcb] ; read next available pcb index
	cmp bx, 32 ; are all PCBs used
	je exit ; yes, exit

	mov cl, 5
	shl bx, cl ; multiply by 32 for pcb start
	mov ax, [bp+8] ; read segment parameter
	mov [pcb+bx+18], ax ; save in pcb space for cs
	mov ax, [bp+6] ; read offset parameter
	mov [pcb+bx+16], ax ; save in pcb space for ip
	mov [pcb+bx+22], ds ; set stack to our segment
	mov si, [nextpcb] ; read this pcb index
	mov cl, 9
	shl si, cl ; multiply by 512
	add si, 256*2+stack ; end of stack for this thread
	mov ax, [bp+4] ; read parameter for subroutine
	sub si, 2 ; decrement thread stack pointer
	mov [si], ax ; pushing param on thread stack
	sub si, 2 ; space for return address
	mov [pcb+bx+14], si ; save si in pcb space for sp
	mov word [pcb+bx+26], 0x0200 ; initialize thread flags
	mov ax, [pcb+28] ; read next of 0th thread in ax
	mov [pcb+bx+28], ax ; set as next of new thread
	mov ax, [nextpcb] ; read new thread index
	mov [pcb+28], ax ; set as next of 0th thread
	inc word [nextpcb] ; this pcb is now used
exit: pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
; timer interrupt service routine
timer: push ds
	push bx

	push cs
	pop ds ; initialize ds to data segment
	mov bx, [current] ; read index of current in bx
	shl bx, 1
	shl bx, 1
	shl bx, 1
	shl bx, 1
	shl bx, 1 ; multiply by 32 for pcb start
	mov [pcb+bx+0], ax ; save ax in current pcb
	mov [pcb+bx+4], cx ; save cx in current pcb
	mov [pcb+bx+6], dx ; save dx in current pcb
	mov [pcb+bx+8], si ; save si in current pcb
	mov [pcb+bx+10], di ; save di in current pcb
	mov [pcb+bx+12], bp ; save bp in current pcb
	mov [pcb+bx+24], es ; save es in current pcb
	pop ax ; read original bx from stack
	mov [pcb+bx+2], ax ; save bx in current pcb
	pop ax ; read original ds from stack
	mov [pcb+bx+20], ax ; save ds in current pcb
	pop ax ; read original ip from stack
	mov [pcb+bx+16], ax ; save ip in current pcb
	pop ax ; read original cs from stack
	mov [pcb+bx+18], ax ; save cs in current pcb
	pop ax ; read original flags from stack
	mov [pcb+bx+26], ax ; save cs in current pcb
	mov [pcb+bx+22], ss ; save ss in current pcb
	mov [pcb+bx+14], sp ; save sp in current pcb
	;push ax
	;push si
	;mov ax,bx
	;mov si,3
	;mul si
	;shl ax,1
	;mov bx,counter
;leave:	add ax,counter
	mov word[pcb+bx+30],counter
;	pop si
;	pop ax
	mov bx, [pcb+bx+28] ; read next pcb of this pcb
	mov [current], bx ; update current to new pcb
	mov cl, 5
	shl bx, cl ; multiply by 32 for pcb start
	mov cx, [pcb+bx+4] ; read cx of new process
	mov dx, [pcb+bx+6] ; read dx of new process
	mov si, [pcb+bx+8] ; read si of new process
	mov di, [pcb+bx+10] ; read di of new process

	mov bp, [pcb+bx+12] ; read bp of new process
	mov es, [pcb+bx+24] ; read es of new process
	mov ss, [pcb+bx+22] ; read ss of new process
	mov sp, [pcb+bx+14] ; read sp of new process
	push word [pcb+bx+26] ; push flags of new process
	push word [pcb+bx+18] ; push cs of new process
	push word [pcb+bx+16] ; push ip of new process
	push word [pcb+bx+20] ; push ds of new process
	mov al, 0x20
	out 0x20, al ; send EOI to PIC
	mov ax, [pcb+bx+0] ; read ax of new process
	mov bx, [pcb+bx+2] ; read bx of new process
	pop ds ; read ds of new process
	iret ; return to new process
key:
	push ax
	push es
	push di
	push bx
	push cx
	push ds
	push cs
	pop ds

display:
	push si
	mov bx,0xb800
	mov es,bx
	mov bx, [current]
	
	mov ax,3
	mul bx
	
	mov si,counter
	mov bx,ax
	add si,bx
	mov ax, si
	mov si,bx
	add si,2
	cmp byte[counter+si],59
	jne move1
	mov byte[counter+si],0
	jmp move3
move1:	inc byte[counter+si]
	jmp blow

move3:	cmp byte[counter+si-1],59
	jne move

	mov byte[counter+si-1],0
	jmp move4
move:	
	inc byte[counter+si-1]
	jmp blow

move4:	cmp byte[counter+si-2],23
	je move2

	inc byte[counter+si-2]
	jmp blow
move2:	mov byte[counter+si-2],0

blow:
	pop ds
	pop si
	pop cx
	pop bx
	pop di
	pop es
	push ax
	jmp bk
print:
	push si
	push cx
	push dx
	push bx
	push di
	push bp
	mov di,0x60
	XOR ax,ax
	mov ax,[bp-10]

	mov cx,[cs:current]
	cmp cx,1
	jbe do
	dec cx
hahah:	add di,160
	loop hahah
	
do:
	mov bp,ax
	XOR ah,ah
	mov al,byte[bp]
	mov si,3
getback:mov  bx, 0xb800
	mov  es, bx            ; point es to video base
	mov  bx, 10             ; use base 10 for division
	mov  cx, 0              ; initialize count of digits
	cmp al,9
	ja nextdigit
	mov word[es:di],0x0730
	add di,2
nextdigit:mov dx,0
	div  bx                 ; divide by 10
	add  dl, 0x30           ; convert digit into ascii value
	push dx                 ; save ascii value on stack
	inc  cx                 ; increment count of values
	cmp  ax, 0              ; is the quotient zero
	jnz  nextdigit          ; if no divide it again

nextpos:pop  dx                 ; remove a digit from the stack
	mov dh, 0x07           ; use normal attribute 
	mov [es:di], dx         ; print char on screen
	add  di, 2              ; move to next screen location
	loop nextpos            ; repeat for all digits on stack
	dec si
miss:	inc bp
	mov al,byte[bp]
	XOR ah,ah
	mov word[es:di],0x073A;add ascii for ':'
	add di,2
	cmp si,0
	jne getback
	pop bp
        pop  di
	pop bx
	pop  dx
	pop  cx
	pop si
	ret 6

start: xor ax, ax
	mov es, ax ; point es to IVT base
	cli
	mov word [es:8*4], timer
	mov [es:8*4+2], cs ; hook timer interrupt
	sti
nextkeypress:
	xor ah, ah ; service 0 – get keystroke
	int 0x16 ; bios keyboard services
	push cs ; use current code segment
	mov ax, mytask
	push ax ; use mytask as offset
	push word [lineno] ; thread parameter
	call initpcb ; register the thread
	inc word [lineno] ; update line number
	jmp nextkeypress ; wait for next keypress