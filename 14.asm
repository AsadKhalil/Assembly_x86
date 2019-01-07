; [org 0x0100]

; jmp start

; ; subroutine to print a number at top left of screen
; ; order of parameters: location, number
; printnum:
	; push bp
	; mov bp, sp
	; push es
	; push ax
	; push bx
	; push cx
	; push dx
	; push di
	
	; mov ax, 0xb800
	; mov es, ax ; point es to video base
	
	; mov ax, [bp+4] ; load number in ax
	; mov di, [bp + 6] ; pointing di to the specified location
	
	; mov bx, 10 ; use base 10 for division
	
; nextdigit: 
	; mov dx, 0 ; zero upper half of dividend
	; div bx ; divide by 10
	; add dl, 0x30 ; convert digit into ascii value
	
	; mov dh, 0x07
	; mov [es:di], dx
	
	; sub di, 2
	; cmp ax, 0 ; is the quotient zero
	; jnz nextdigit ; if no divide it again

	; pop di
	; pop dx
	; pop cx
	; pop bx
	; pop ax
	; pop es
	; pop bp
	; ret 4
	
; start:
	; mov ax, 158
	; push ax
	
	; mov ax, 0xA
	; push ax
	; call printnum
	
	; mov ax, 0x4c00
	; int 21h
	
	
	
	;number printing algorithm 
[org 0x0100]               
jmp  start  ;;;;; COPY LINES 008-025 FROM EXAMPLE 6.2 (clrscr) ;;;;;  ; subroutine to print a number at top left of screen ; takes the number to be printed as its parameter 
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
	mov bx,16 ; use base 10 for division
	mov cx, 0 ; initialize count of digits
nextdigit:
	 mov dx, 0 ; zero upper half of dividend
	div bx ; divide by 10
	add dl, 0x30 ; convert digit into ascii value
	cmp dl, 0x3A
	jb skip
	add dl, 7
skip:
	push dx ; save ascii value on stack
	inc cx ; increment count of values
	cmp ax, 0 ; is the quotient zero
	jnz nextdigit ; if no divide it again
	mov di, 0 ; point di to top left column
nextpos: 
	pop dx ; remove a digit from the stack
	mov dh, 0x07 ; use normal attribute
	mov [es:di], dx ; print char on screen
	add di, 2 ; move to next screen location
	loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2
start: 
      ; call  clrscr            ; call the clrscr subroutine    
	   mov ax, 4545   
	   push ax                 ; place number on stack   
	   call printnum           ; call the printnum subroutine       
	   mov ax, 0x4c00          ; terminate program          
	   int 0x21