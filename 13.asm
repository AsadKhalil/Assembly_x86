[org 0x100]
jmp start

msg: db 'my screen saver'
size: db 15
store: times 2000 dw 0
key:dw 0
timer:dw 0
oldisr: dd 0
format :db 01h



clrscr: push es
push ax
push cx
push di

mov ax, 0xb800
mov es, ax
xor di, di 
mov ax, 0x0720 
mov cx, 2000 

cld 

rep stosw 

pop di
pop cx
pop ax
pop es
ret

delay:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push si 
push di

mov dx,0
mov bx,0
mov di,0
mov cx,0xffff

n: add bx,1
loop n


pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret 
save:
push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push es
push ds
push ds
pop es


mov cx ,2000
mov di,[bp+4]
mov ax,0xb800
mov ds, ax
mov si,0
n1: lodsw
stosw
loop n1
pop ds
pop es
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 2 

load: push bp 
mov bp ,sp
push es
push ax
push cx
push si
push di
push ds
push es
mov si,[bp+4]
mov ax, 0xb800
mov cx,2000
mov es ,ax
mov di,0
n2: lodsw
stosw
loop n2

pop es
pop ds
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 2  

print:
push bp
mov bp, sp
push es
push ax
push cx
push si
push di

mov ax, [bp+8]
mov bx, 0xb800
mov es, bx 
mov di, 1920+60 
mov si, [bp+6] 
mov cx, [bp+4] 
mov dx,0


nextchar: mov al, [si] 
mov [es:di], ax 
add di, 2 
add si, 1 
add dx,1
loop1:loop nextchar 
call delay

pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 

kbisr:
push si
push di
push bx
push cx
push ax
push es

cmp word [cs:timer],100
jb skip
push store
call load
skip:
mov word [cs:key],1
mov word [cs:timer],0
mov al, 0x20
out 0x20, al ; send EOI to PIC
pop es
pop ax
pop cx
pop bx
pop di
pop si
jmp far [cs:oldisr]
;ret
timerisr:
push si
push di
push bx
push cx
push ax
push es
push cs
pop ds

inc word[cs: timer]
cmp word [cs:timer],100
jb skipall

jmp nxt0
saving: push store
call save
call clrscr
jmp nxt2

nxt0:cmp word[timer],100
je saving
nxt2:mov word[key],0
cmp word[timer],100
ja nxt4
jmp skipall

nxt4:mov ax,0
mov ah,[format]
mov ch,ah
push ax
add ch,0x01
mov [format],ch
cmp ch,0x08
jb nxt3
mov ch,0x01
mov [format],ch
nxt3:
mov ax,msg
push ax
mov ax,0
mov al,[size]
push ax
call print



skipall:
mov al ,0x20
out 0x20,al
pop ax
pop ax
pop ax
pop es
pop ax
pop cx
pop bx
pop di
pop si
iret

start: xor ax, ax
mov es, ax 
mov ax, [es:9*4]
mov [oldisr], ax 
mov ax, [es:9*4+2]
mov [oldisr+2], ax 
;call kbisr
;call timerisr
cli 
mov word [es:9*4], kbisr 
mov [es:9*4+2], cs 
mov word [es:8*4], timerisr
mov [es:8*4+2], cs 
sti 
mov dx, start 
add dx, 15 
mov cl, 4
shr dx, cl 
mov ax, 0x3100
int 0x21