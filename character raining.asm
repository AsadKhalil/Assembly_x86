[org 0x100]
jmp start
update:
cli
push es
push cx
push bx
push si
sti
mov cx,0xb800
mov es,cx
mov bx,3998
mov si,bx
sub si,160
u1:
mov cx,[es:si]
mov [es:bx],cx
sub bx,2
sub si,2
cmp si,-2
je u2
jmp u1
u2:
mov bx,158
lp:
mov word[es:bx],0x0720
sub bx,2
cmp bx,-2
jge lp
ue:
pop es
pop cx
pop bx
pop si
ret


timer:
push ax

add word[cs:count],2
cmp word[cs:count],160
jl t1
mov word[cs:count],0
t1:
call update

mov al, 0x20
out 0x20, al 
pop ax

iret 
start:
mov ax,0
mov es,ax
cli 
mov word [es:8*4],timer
mov [es:8*4+2],cs 
sti

l1:

mov ah,0
int 0x16
mov dl,al

cli
mov dh,7
mov si,[cs:count]
mov cx,0xb800
mov es,cx
mov [es:si],dx
sti
jmp l1

mov ax,0x4c00
int 21h
count:dw 0