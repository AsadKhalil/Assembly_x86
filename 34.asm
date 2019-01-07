[org 0x0100]

jmp start

nodes: times 1024 dd 0
firstfree:	dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This fucntion chains all 1024 nodes
init:
	;saving all used registers
	push ax
	push bx
	push cx
	
	mov cx, 0
	
	mov ax, nodes
	mov word [firstfree], ax

loop1:
	add ax, 4

	mov word [nodes + bx], ax
	
	add bx, 4
	
	inc cx
	
	cmp cx, 1023
	jnz loop1

	
endfunc:
	pop cx
	pop bx
	pop ax
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This function returns the node 
;offset stored in firstfree and 
;sets fisrtfree to the offset 
;stored in the later two bytes
;of that node.
createlist:
	push bx
	push cx

	mov ax, [firstfree]
	mov	bx, ax
	mov cx, [bx]
	mov word [firstfree], cx
	mov cx, 0
	mov word [bx], cx


endoffunc:
	pop cx
	pop bx
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This function takes two
;parameters, the offset of a node
;and a word data. It removes
;one node from freelist and inserts
;it after the said node and updates
;the node's data part.

insertafter:
	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push bx
	push dx
	push si
	
	mov dx, [bp + 4]	;storing a word data
	mov bx, [bp + 6]	;storing the offset of the parameter node
	
	call createlist		;returns the value in ax
	
	mov si, [bx]		;storing offset stored in the parameter node

	mov word [bx], ax	;replacing the offset stored in the parameter node by the node returned by createlist function
	mov bx, ax			;moving offset stored in ax to bx
	
	mov word [bx], si
	mov word [bx + 2], dx	;moving data stored in dx to node whose offset is stored in bx
	
	
	
	;reseting values
	pop si
	pop dx
	pop bx
	pop ax
	pop bp
	ret 2	;it will first return the address to ip and then it will remove two elements from the stack

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This function takes a node as
;its parameter and removes the
;node immediately after it in
;the linked list if there is one

deleteafter:
	push bp
	mov bp, sp
	
	;saving registers
	push ax
	push bx
	push si
	
	mov bx, [bp + 4]	;storing the offset of the parameter node
	
	mov si, [bx]	;move the offset stored at bx into si
	
	mov ax, [si]	;move the offset stored at si into ax
	mov word [si], 0
	mov word [si + 2], 0
	
	mov [bx], ax
	
	pop si
	pop bx
	pop ax
	pop ax
	
	ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This function will delete all
;the linked list after the
;specified node

deletelist:
	push bp
	
	mov bp, sp
	
	;saving registers
	push ax
	push bx
	
	mov bx, [bp + 4] ;moving parameter(node offset) into bx
	
dellist:
	mov ax, [bx]
	mov word [bx], 0
	mov word [bx + 2], 0

	add bx, 4
	
	cmp word [bx], 0
	jnz dellist
	
	pop bx
	pop ax
	pop bp
	
	ret 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
start:
	call init
	
	mov ax, 0x010F
	push ax
	mov ax, 0xABCD
	push ax
	
	call insertafter
	
	mov ax, 0x010F
	push ax
	
	call deleteafter
	
	mov ax, 0x010F
	push ax
	call deletelist
	
finish:
	mov ax, 0x04c00
	int 21h