[org 0x0100]

   jmp start

PCB: times 9*16 dw 0
stack: times 9*256 dw 0
nextPCB: dw 1
current: dw 0
string: db ' Visit www.hazacs.com for more...',0
xPos: dw 0
yPos:dw 0

clearScreen:

   pusha
  
   mov ax , 0xB800
   mov es , ax
   mov di , 0
   mov ax , 0x0720
   mov cx , 2000
  
   rep stosw
  
   popa
   ret
  
delay:
  
   pusha
  
   mov dx , 0

   outerDelay:
      mov cx , 0XFFFF

   putDelay:
      loop putDelay
     
      inc dx
      cmp dx , 0x0001
      jl outerDelay
  
   popa 
   ret

strlen:
   push bp
   mov bp , sp
  
   push ax
   push cx
   push es
   push di
  
   les di , [bp+4]
   mov cx , 0xFFFF
   xor al , al
   repne scasb
   mov ax , 0xFFFF
   sub ax , cx
   dec ax
   mov [bp+8] , ax
  
   pop di
   pop es
   pop cx
   pop ax
   pop bp
   ret 4
  
colorTask:   ;[BP+8]=x-coord    [BP+6]=y-coord   [BP+4]=color
   push bp
   mov bp , sp
  
   push ax
   push bx
   push cx
   push dx
   push si
   push di
   push es
  
   push 0xB800
   pop es
  
   mov al , 80
   mul byte [bp+6]
   add ax , [bp+8]
   shl ax , 1
  
   mov bx , ax
  
   printColor:
      mov ax , [bp+4]
      mov dx , 0

      printOuterLoop:
          mov di , bx
          mov cx , 6

          printInnerLoop:
             stosw
             add di , 158
             loop printInnerLoop
             call delay
             inc dx
             cmp dx , 40
             jnl rubColor
             add bx , 2
             jmp printOuterLoop

   rubColor:
      mov ax , 0x0720
      mov dx , 0

   rubOuterLoop:
          mov di , bx
          mov cx , 6

          rubInnerLoop:
             stosw
             add di , 158
             loop rubInnerLoop
             call delay
             inc dx
             cmp dx , 40
             jnl printColor
             sub bx , 2
             jmp rubOuterLoop

   pop es
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   pop bp
   ret 6


stringTask:        ;[BP+6]=x-coord          [BP+4]=y-coord
   push bp
   mov bp , sp
   push ax
   push bx
   push cx
   push dx
   push si
   push di
   push es
  
   push cs
   pop ds
   push 0xB800
   pop es
  
   mov al , 80
   mov cl , [bp+6]
   add cl , 2
   mul cl
   add ax , [bp+8]
   shl ax , 1
  
   mov bx , ax 
  
   mov di , [bp+4]
   sub sp , 2
   push ds
   push di
   call strlen
   pop dx          ;DX=size of the string
  
   printString:
      mov di , bx
      mov si , [bp+4]
      mov ah , 0x07
      mov cx , dx
      cld

      strPrtLoop:
          lodsb
          stosw
          call delay
          loop strPrtLoop

   rubString:
      mov ax , 0x0720
      mov cx , dx
      std

      strRubLoop:
          stosw
          call delay
          loop strRubLoop
     
   jmp printString
   pop es
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   pop bp
   ret 4
  
initializePCB:
   push bp
   mov bp , sp
   push ax
   push bx
   push cx
   push si
  
   mov bx , [nextPCB]
   cmp bx , 9
   jz finish
  
   mov cl , 5
   shl bx , cl
  
   mov ax , [bp+12]             ;read segment
   mov [PCB+bx+18] , ax
   mov ax , [bp+10]             ;read offset
   mov [PCB+bx+16] , ax
  
   mov [PCB+bx+22] , ds
   mov si , [nextPCB]
   mov cl , 9
   shl si , cl
   add si , 256*2+stack
   mov ax , [bp+6]
   sub si , 2
   mov [si] , ax             ;x-coord
   mov ax , [bp+4]
   sub si , 2
   mov [si] , ax             ;y-coord
   mov ax , [bp+8]
   sub si , 2
   mov [si] , ax             ;color/string
   sub si , 2
   mov [PCB+bx+14] , si
  
   mov word [PCB+bx+26]  , 0x200
   mov ax , [PCB+28]
   mov [PCB+bx+28] , ax
   mov ax , [nextPCB]
   mov [PCB+28] , ax
   inc word [nextPCB]
  
   finish:
      pop si
      pop cx
      pop bx
      pop ax
      pop bp
      ret 10
  
timer:
   push ds
   push bx
  
   push cs
   pop ds
  
   mov bx , [current]
   shl bx , 5
  
   mov [PCB+bx+0] , ax
   mov [PCB+bx+4] , cx
   mov [PCB+bx+6] , dx
   mov [PCB+bx+8] , si
   mov [PCB+bx+10] , di
   mov [PCB+bx+12] , bp
   mov [PCB+bx+24] , es
  
   pop ax
   mov [PCB+bx+2] , ax
   pop ax
   mov [PCB+bx+20] , ax
   pop ax
   mov [PCB+bx+16] , ax
   pop ax
   mov [PCB+bx+18] , ax
   pop ax
   mov [PCB+bx+26] , ax
  
   mov [PCB+bx+22] , ss
   mov [PCB+bx+14] , sp
  
   mov bx , [PCB+bx+28]
   mov [current] , bx
   shl bx , 5
  
   mov cx , [PCB+bx+4]
   mov dx , [PCB+bx+6]
   mov si , [PCB+bx+8]
   mov di , [PCB+bx+10]
   mov bp , [PCB+bx+12]
   mov es , [PCB+bx+24]
   mov ss , [PCB+bx+22]
   mov sp , [PCB+bx+14]
  
   push word [PCB+bx+26]
   push word [PCB+bx+18]
   push word [PCB+bx+16]
   push word [PCB+bx+20]
  
   mov al , 0x20
   out 0x20 , al
  
   mov ax , [PCB+bx+0]
   mov bx , [PCB+bx+2]
   pop ds
   iret
  
  
start:
   call clearScreen
   push 0
   pop es

   cli
      mov word [es:8*4] , timer
      mov [es:8*4+2] , cs
   sti
  
   nextKey:
      xor ah , ah
      int 0x16
     
      push cs
     
      cmpStr:
          cmp al , 115
          jnz blue
          push stringTask
          push string
          jmp proceed

      blue:
          cmp al , 98 
          jnz green
          push colorTask
          push 0x1020
          jmp proceed

      green:
          cmp al , 103 
          jnz cyan
          push colorTask
          push 0x2020
          jmp proceed

      cyan:
          cmp al , 99 
          jnz red
          push colorTask
          push 0x3020
          jmp proceed

      red:
          cmp al , 114 
          jnz magenta
          push colorTask
          push 0x4020
          jmp proceed

      magenta:
          cmp al , 109 
          jnz orange
          push colorTask
          push 0x5020
          jmp proceed

      orange:
          cmp al , 111 
          jnz white
          push colorTask
          push 0x6020
          jmp proceed

      white:
          cmp al , 119 
          jnz nextKey
          push colorTask
          push 0x7020
         
   proceed:
      push word [xPos]
      push word [yPos]
      call initializePCB
  
      cmp word [xPos] , 0
      jnz reset
      mov word [xPos] , 40
      jmp nextKey

      reset:
          mov word [xPos] , 0
          add word [yPos] , 6
          jmp nextKey
