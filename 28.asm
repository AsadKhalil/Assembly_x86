[org 0x0100]

jmp start

array: dw 10, 8, 6, 4, 2, 1 ;re-arrange the elements. The program will
							;sort it in descending order itself
size: dw 6
swap: db 0

lb: dw 0
ub: dw 0
mid: dw 0
ele: dw 4	;the element to be searched
flag: dw 0

start:
	;sorting in descending order
	mov bx, 0 ; initialize array index to zero
	mov cx, 1
	mov byte [swap], 0 ; rest swap flag to no swaps

loop1:
	mov ax, [array+bx] ; load number in ax
	cmp ax, [array+bx+2] ; compare with next number
	
	jae noswap ; no swap if already in order
	
	mov dx, [array+bx+2] ; load second element in dx
	mov [array+bx+2], ax ; store first number in second
	mov [array+bx], dx ; store second number in first
	mov byte [swap], 1 ; flag that a swap has been done
	
noswap:
	add bx, 2 ; advance bx to next index
	
	inc cx
	cmp cx, [size]
	jnz loop1 ; if not compare next two
	
	cmp byte [swap], 1 ; check if a swap has been done
	je start ; if yes make another pass
	
	;binary search
	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov dx, 0

	mov ax, [size]
	dec ax
	mov word [ub], ax
	
search:
	mov ax, [lb]
	cmp ax, [ub]
	jg endsearch
	
	add ax, [ub]
	mov cx, 2
	
	cmp ax, 1
	jz skip3
	div cx
skip3:
	mul cl
	
	mov bx, ax
	
	mov ax, [array + bx]
	cmp ax, [ele]
	jz endsearch2
	
	cmp ax, [ele]
	ja skip2
	
	mov ax, [lb]
	add ax, [ub]
	mov cx, 2
	mov dx, 0
	div cx
	mov bx, ax
	cmp bx, 0
	jz skip4
	
	dec bx ;mid - 1
 skip4: 
	mov word[ub], bx
	jmp search
	
skip2:
	mov ax, [lb]
	add ax, [ub]
	mov cx, 2
	mov dx, 0
	div cx
	mov bx, ax
	inc bx
	mov word [lb], bx
	jmp search
	
endsearch2:
	mov word [flag], 1
	
endsearch:
	cmp word [flag], 1
	jz found

	mov ax, 0
	jmp finish
	
found:
	mov ax, 1
	
finish:
	mov dx, ax ;just for checking
	mov ax, 0x04c00
	int 21h