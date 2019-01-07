[org 0x0100]
jmp main

; Note :
; Please Do Not Change Any Of The Variable Values
; What Ever Is Generic We Have Already Provided It In Our Menu List

oldisr : dd 0
oldtimerisr : dd 0 
tickcount : dw 0 
ball_String : db 'O' 
ball_Row : dw 16
ball_Column : dw 5
ball_attribute: dw 0
ball_Index : dw 0
wait_a_sec: dw 0
northeast: dw 0
northwest: dw 0
southeast: dw 1
southwest: dw 0
north:     dw 0
south:     dw 0
score : dw 0
life : dw 3 
second_tickcount: dw 0
seconds: dw 0
minutes: dw 0
menu_String1 : db 'Press 1 For Level 1' , 0	
menu_String2 : db 'Press 2 For Level 2' , 0	
menu_String3 : db 'Press 3 For Level 3' , 0
menu_String4 : db 'No ? Want To Design Your Own Board So Press Any Other Key But Note that You      Would Have To Care For Number of Bricks Per line According to its size' , 0						   
menu_String5 : db 'Enter Total Number Of Lines For Bricks in the range from 0 - 9               (Please Do Not Press Any Other Key)' , 0	
menu_String6 : db 'Enter Total Number Of Bricks Per Line in the range from 0 - 9                (Please Do Not Press Any Other Key)' , 0
menu_String7 : db 'Enter size of Your Brick in the range from 0 - 9                             (Please Do Not Press Any Other Key)' , 0
menu_String8 : db 'Welcome To Level : ' , 0
menu_String10 : db 'Welcome To The Level That You Have Designed Yourself' , 0		
menu_String9 : db 'press any key to continue' , 0	
left_Boundry : dw 1
right_Boundry : dw 12
random_Number : dw 3 
left_Inner_Boundry : dw 4
right_Inner_Boundry : dw 9
                 
border_Character1 : db '%'         ; do not change length because i set border to be of one character only
border_Character2 : db '#'         ; do not change length because i set border to be of one character only
brick_String : db '                ' , 0 ; length can be changed but add spaces only()
                                   ; Note: update brick_String and number_Of_Bricks_Per_Lines accordingly by keeping it mind 
								   ; that it will not create any mess up and if you want to change length of brick_String just 
								   ; add or remove spaces in brick_String do not change length_Brick_String

								   
length_Brick_String : dw 0         ; will calculate length during Program whatever it is(do not do anything)
number_Of_Bricks_Lines : dw 0     ; will decide How many lines of bricks will be there -> Can Be Changed
                                   ; (and do not exceed it 11 otherwise it will print on border area but there will be no error still)

number_Of_Bricks_Per_Lines : dw 0 ; will decide How many brickes will be there per line -> Can Be Changed
                                  ; (and do not exceed it 11 otherwise it will mixup printing but there will be no error still)

bar_String : db '            ' , 0     ; do not change its length but character can be changed
empty_String : db '            ' , 0         ; do not change
row : dw 0
column : dw 0
score_String : db 'SCORE:',0
lives_String : db 'LIVES:'  , 0
time_String : db 'TIME:'  , 0
date_String : db 'DATE:'  , 0
level_String : db 'LEVEL:'  , 0
toatl_bricks_String : db 'Bricks : '  , 0
margin_Line_String : db '-'
flag : db 0
attribute : dw 18
counter : dw 0
startUp_String : db '                ' , 0
startUpcharacter_String : db '  ' , 0
flag1 : dw 0
bricks_Counter : dw 0
level : dw 0
game_over_string : db 'Game Over You LOSE Better Luck Next Time' , 0
game_win_string : db 'Game Over You WIN' , 0

subroutine_Game_Over :


pusha
push word[row]
push word[column] 
call subroutine_clrscr
mov ax , 0x0A                          ; pushing attribute of score_String                      
push ax
mov ax , game_over_string
push ax
call strlen
push ax 
mov word [column], 25
mov word [row], 12; pushing length of bscore_String
push word[row] 
push word[column]
mov bx , game_over_string   
push bx                                ; pushing offset of score_String
call subroutine_My_Print_String
mov ah , 0
int 0x16
mov ax , 0x4c00
int 0x21 
pop word[column]
pop word[row]
popa
ret
subroutine_Game_Win :
pusha
push word[row]
push word[column] 
call subroutine_clrscr
mov ax , 0x0A                          ; pushing attribute of score_String                      
push ax
mov ax , game_win_string
push ax
call strlen
push ax 
mov word [column], 25
mov word [row], 12; pushing length of bscore_String
push word[row] 
push word[column]
mov bx , game_win_string   
push bx                                ; pushing offset of score_String
call subroutine_My_Print_String
mov ah , 0
int 0x16
mov ax , 0x4c00
int 0x21 
pop word[column]
pop word[row]
popa
ret
subroutine_print_timer:
push ax
push bx
	push cs 
	pop ds
	mov ax, 0xb800
	mov es, ax
	mov bh, 0x07
	mov bl, ':'
	mov [es:3576], bx 
	cmp word [seconds], 59 
	je incmin
	inc word [seconds]
	jmp print_karo_timer

incmin:
	inc word [minutes]
	mov word [seconds], 0
	 
	
print_karo_timer:
	mov ax , 3572
	push ax
	push word[minutes]
	call subroutine_Print_Score
	cmp word [seconds], 10
	jl singl_prints
	mov ax , 3578
	push ax
	push word[seconds]
	call subroutine_Print_Score
	jmp bas_karo
singl_prints:
	mov ax , 3580
	push ax
	push word[seconds]
	call subroutine_Print_Score
	mov ax, 0xb800
	mov es, ax
	mov bx, 0x0730
	mov [es:3578], bx
	
	
bas_karo:
pop bx
pop ax
	
ret



subroutine_State :                      ; subroutine that will print score , lives , date and time strings 
pusha
push word[row]
push word[column]


; will print (SCORE : ) on 22th row and 1st column
mov word[row] , 22
mov word[column] , 1

mov ax , 0x0A                          ; pushing attribute of score_String                      
push ax
mov ax , score_String
push ax
call strlen
push ax                                ; pushing length of bscore_String
push word[row] 
push word[column]
mov bx , score_String   
push bx                                ; pushing offset of score_String
call subroutine_My_Print_String


; will print (LIVES : ) on 22th row and 11th column
mov word[row] , 22
mov word[column] , 11

mov ax , 0x0A                          ; pushing attribute of lives_String                     
push ax
mov ax , lives_String
push ax
call strlen
push ax                                ; pushing length of lives_String
push word[row] 
push word[column]
mov bx , lives_String   
push bx                                ; pushing offset of lives_String
call subroutine_My_Print_String


; will print (TIME : ) on 22th row and 20th  column
mov word[row] , 22
mov word[column] , 20

mov ax , 0x0A                          ; pushing attribute of time_String                     
push ax
mov ax , time_String
push ax
call strlen
push ax                                ; pushing length of time_String
push word[row] 
push word[column]
mov bx , time_String   
push bx                                ; pushing offset of time_String
call subroutine_My_Print_String



; will print level on 22th row and 36th column
mov word[row] , 22
mov word[column] , 36

mov ax , 0x06                          ; pushing attribute of level_String                      
push ax
mov ax , level_String
push ax
call strlen
push ax                                ; pushing length of level_String
push word[row] 
push word[column]
mov bx , level_String   
push bx                                ; pushing offset of level_String
call subroutine_My_Print_String

mov ax , 0xb800
mov es , ax
mov ax , [level]
mov ah , 0x0A
add al , 0x30
mov word [es : 3606] , ax 


mov word[row] , 22
mov word[column] , 46

mov ax , 0x0A                          ; pushing attribute of date_String                      
push ax
mov ax , toatl_bricks_String
push ax
call strlen
push ax                                ; pushing length of date_String
push word[row] 
push word[column]
mov bx , toatl_bricks_String   
push bx                                ; pushing offset of date_String
call subroutine_My_Print_String
mov ax , 3630
push ax
mov ax , [bricks_Counter]
push ax 
call subroutine_Print_Score

; will print (DATE : ) on 22th row and 38th column
mov word[row] , 22
mov word[column] , 63

mov ax , 0x0A                          ; pushing attribute of date_String                      
push ax
mov ax , date_String
push ax
call strlen
push ax                                ; pushing length of date_String
push word[row] 
push word[column]
mov bx , date_String   
push bx                                ; pushing offset of date_String
call subroutine_My_Print_String

; will print a line over the score , lives , date and time variables on 21th row
mov word[row] , 21
mov word[column] , 1
mov cx , 78

label_a :
mov ax , 0x0A                          ; pushing attribute of margin_Line_String                      
push ax
mov ax , 1           
push ax                                ; pushing length of margin_Line_String
push word[row] 
push word[column]
mov bx , margin_Line_String  
push bx                                ; pushing offset of margin_Line_String
call subroutine_My_Print_String
add word[column] , 1
loop label_a

exit_subroutine_State : 

pop word[column]
pop word[row]
popa
ret

subroutine_Bricks_Counter :
pusha 
push cs 
pop ds
mov ax , [number_Of_Bricks_Lines]
dec ax 
mov bx , [number_Of_Bricks_Per_Lines]
mov dx , 0
mul bx
mov dx , 0
mov [bricks_Counter] , ax

popa
ret

subroutine_Print_Score : 
printnum: push bp
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
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, [bp + 6] ; point di to top left column
nextpos: pop dx ; remove a digit from the stack
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
ret 4


subroutine_Menu : 
pusha
push word[row]
push word[column]
mov dx , 0x0A
push dx 
mov ax , menu_String1
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 4                           ; pushing length of string 
push word[row]
mov word[column] , 30                           ; pushing length of string 
push word[column]
mov bx , menu_String1               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov dx , 0x0A
push dx 
mov ax , menu_String2
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 6                           ; pushing length of string 
push word[row]
mov word[column] , 30                           ; pushing length of string 
push word[column]
mov bx , menu_String2               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov dx , 0x0A
push dx 
mov ax , menu_String3
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 8                           ; pushing length of string 
push word[row]
mov word[column] , 30                           ; pushing length of string 
push word[column]
mov bx , menu_String3               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov dx , 0x0A
push dx 
mov ax , menu_String4
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 1                           ; pushing length of string 
push word[column]
mov bx , menu_String4               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov ah , 0
int 0x16
cmp al , 49
jne near check_Other1
mov word[number_Of_Bricks_Lines] , 4
mov word[number_Of_Bricks_Per_Lines] , 10
call subroutine_Bricks_Counter
mov word[level] , 1
call subroutine_clrscr
mov dx , 0x0A
push dx 
mov ax , menu_String8
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 7                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String8               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ax , 0xb800
mov es , ax
mov ax , [level]
mov ah , 0x0A
add al , 0x30
mov word [es : 1210] , ax 
mov dx , 0x0A
push dx 
mov ax , menu_String9
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String9               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ah , 0 
int 0x16
call subroutine_clrscr
call subroutine_startUp
mov ax , 5
push ax
mov ax , brick_String
push ax
call subroutine_Bricks
jmp exit_subroutine_Menu

check_Other1 : 
cmp al , 50
jne near check_Other2
mov word[number_Of_Bricks_Lines] , 6
mov word[number_Of_Bricks_Per_Lines] , 7
call subroutine_Bricks_Counter
mov word[level] , 2
call subroutine_clrscr
mov dx , 0x0A
push dx 
mov ax , menu_String8
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 7                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String8               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ax , 0xb800
mov es , ax
mov ax , [level]
mov ah , 0x0A
add al , 0x30
mov word [es : 1210] , ax 
mov dx , 0x0A
push dx 
mov ax , menu_String9
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String9               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ah , 0 
int 0x16
call subroutine_clrscr
call subroutine_startUp

mov ax , 8
push ax
mov ax , brick_String
push ax
call subroutine_Bricks
jmp exit_subroutine_Menu

check_Other2 :
cmp al , 51
jne near skip_A
mov word[number_Of_Bricks_Lines] , 7
mov word[number_Of_Bricks_Per_Lines] , 5
call subroutine_Bricks_Counter
mov word[level] , 3
call subroutine_clrscr
mov dx , 0x0A
push dx 
mov ax , menu_String8
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 7                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String8               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ax , 0xb800
mov es , ax
mov ax , [level]
mov ah , 0x0A
add al , 0x30
mov word [es : 1210] , ax 
mov dx , 0x0A
push dx 
mov ax , menu_String9
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String9               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ah , 0 
int 0x16
call subroutine_clrscr
call subroutine_startUp
mov ax , 13
push ax
mov ax , brick_String
push ax
call subroutine_Bricks
jmp exit_subroutine_Menu
skip_A :
call subroutine_clrscr
mov dx , 0x0A
push dx 
mov ax , menu_String5
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 5                           ; pushing length of string 
push word[column]
mov bx , menu_String5               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String 
mov word[level] , 0
mov ah , 0
int 0x16
sub al , 48
mov ah , 0
mov [number_Of_Bricks_Lines] , ax
inc word[number_Of_Bricks_Lines]
call subroutine_clrscr
mov dx , 0x0A
push dx 
mov ax , menu_String6
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 12                           ; pushing length of string 
push word[row]
mov word[column] , 5                           ; pushing length of string 
push word[column]
mov bx , menu_String6               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String 
mov ah , 0
int 0x16
sub al , 48
mov ah , 0
mov [number_Of_Bricks_Per_Lines] , ax
call subroutine_clrscr
call subroutine_Bricks_Counter
mov dx , 0x0A
push dx 
mov ax , menu_String7
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 14                         ; pushing length of string 
push word[row]
mov word[column] , 5                           ; pushing length of string 
push word[column]
mov bx , menu_String7               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String 
mov ah , 0
int 0x16
sub al , 48
mov ah , 0
mov [length_Brick_String] , ax
call subroutine_clrscr

mov dx , 0x0A
push dx 
mov ax , menu_String10
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 7                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String10               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov dx , 0x0A
push dx 
mov ax , menu_String9
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 25                           ; pushing length of string 
push word[column]
mov bx , menu_String9               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
mov ah , 0
int 0x16
call subroutine_clrscr
call subroutine_startUp


mov dx , 0x0A
push dx 
mov ax , menu_String5
push ax 
call strlen                          ; pushing attribute of brick_String                                        
push ax   
mov word[row] , 10                           ; pushing length of string 
push word[row]
mov word[column] , 5                           ; pushing length of string 
push word[column]
mov bx , menu_String5               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
call subroutine_clrscr

mov ax , [length_Brick_String]
push ax
mov ax , brick_String
push ax
call subroutine_Bricks

exit_subroutine_Menu
pop word[column]
pop word[row]
popa
ret

 
Subroutine_after__Brick_Broken : 
pusha
push cs 
pop ds


		cmp word[minutes], 2
		jge choro
		mov di , 3534 
		push di
		add word[score] , 10
		push word[score]
		call subroutine_Print_Score
		
		choro:
		call subroutine_Sound
	
		dec word[bricks_Counter]
		cmp word [bricks_Counter], 10
		jl thora_wala
		mov di , 3630
        push di
		mov di , [bricks_Counter]
		push di 
		call subroutine_Print_Score
		jmp khatam_karo
		thora_wala:
		mov di , 3632
        push di
		mov di , [bricks_Counter]
		push di 
		call subroutine_Print_Score
		mov ax, 0xb800
		mov es, ax
		mov bx, 0x0730
		mov [es:3630], bx
		
		khatam_karo:
		

popa 
ret 



check_attrib:
	push bp
	mov bp, sp
	pusha
	push cs 
	pop ds
	mov ah, 0
	mov al, 80 ; load al with columns per row
	mov cx, [ball_Row]
	mov ch ,0
	
	mul cl 	 ; multiply with y position
	add ax, [ball_Column] ; add x position
	shl ax, 1 ; turn into byte offset
	mov di, ax ; point di to required location
	mov [ball_Index] , di
	mov ax, 0xb800
	mov es,   ax
	mov ax, [es:di]
	mov word [ball_attribute], ax

	;mov ah, 0x07

	 
	popa
	pop bp
	ret
check: 
	pusha
	push cs 
	pop ds
	mov ax, word [ball_Column]
	mov bx, word [ball_Row]

	mov dx , 07
	push dx                             ; pushing attribute of brick_String 
    mov dx , 1
    push dx
	
	push word[ball_Row]
	push word[ball_Column]
    mov dx , empty_String               ; pushing offset of brick_String
    push dx
    call subroutine_My_Print_String
	
	cmp bx, 20
	jne u23
	
	mov word [ball_Row], 14
	mov bx, 14
	push cx
	push bx
	mov cx, 0 
	mov bx, 0
mov cx , 5000
lo :
mov bx , 5000
lp :
dec bx
jnz lp 

dec cx 
loop lo
	
	
	pop bx
	pop cx
	sub word [life], 1
	push ax
	
	mov ax , 3556
	push ax
	push word[life]
	call subroutine_Print_Score
	
	pop ax

	cmp word[life], 0
	jne u23
	call subroutine_Game_Over
u23:
	
	cmp word [northeast], 0
	jne near nnee
	cmp word [northwest], 0
	jne near nnww
	cmp word [southeast], 0
	jne near ssee
	cmp word [southwest], 0
	jne near ssww
	cmp word [north], 0
	jne near nnnn
	cmp word [south], 0
	jne near ssss
	jmp agay

nnee:
		cmp ax, 77
		jne c1
		mov word [northeast], 0
		mov word [northwest], 1
		jmp agay
		
	c1:	cmp bx, 1
		jne skip1
		mov word [northeast], 0
		mov word [southeast], 1
		jmp agay
	skip1:
		mov cx, [ball_attribute]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and dx , cx
		cmp dx, 0
		je skipp1
		mov word [northeast], 0
		mov word [southeast], 1
		call subroutine_Clear_Brick
		jmp agay
	skipp1:	
		inc ax ;col 
		dec bx ;row
		jmp agay
nnww:
		cmp ax, 2
		jne c2
		mov word [northwest], 0
		mov word [northeast], 1
		
	c2:	cmp bx, 1
		jne skip2
		mov word [northwest], 0
		mov word [southwest], 1
		jmp agay
	skip2:
		mov cx, [ball_attribute]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and dx , cx
		cmp dx, 0
		je skipp2
		mov word [northwest], 0
		mov word [southwest], 1
		call subroutine_Clear_Brick
		jmp agay
	skipp2:	
		dec ax ;col 
		dec bx ;row
		jmp agay
ssee:

		cmp ax, 77
		jne c3
		mov word [southeast], 0
		mov word [southwest], 1
		jmp agay
	c3:	cmp bx, 18
		jne skip3
		 cmp ax, [right_Boundry]
		 ja skip3
		 cmp ax, [left_Boundry]
		 jb skip3
		 cmp ax, [left_Inner_Boundry]
		jb aw3
		cmp ax, [right_Inner_Boundry]
		ja ae3
		mov word [southeast], 0
		mov word [north], 1
		jmp a3
ae3:	mov word [southeast], 0
		mov word [northeast], 1
		jmp a3
aw3:	mov word [southeast], 0
		mov word [northeast], 1
		
a3:		call subroutine_Sound
	skip3:
		mov cx, [ball_attribute]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and dx , cx
		cmp dx, 0
		je skipp3
		mov word [southeast], 0
		mov word [northeast], 1
		call subroutine_Clear_Brick
		jmp agay
skipp3:	inc ax ;col 
		inc bx ;row
		jmp agay
ssww:
		cmp ax, 2
		jne c4
		mov word [southwest], 0
		mov word [southeast], 1
	c4:	cmp bx, 18
		jne skip4
		cmp ax, [right_Boundry]
		ja skip4
		cmp ax, [left_Boundry]
		jb skip4
		
		cmp ax, [left_Inner_Boundry]
		jb aw4
		cmp ax, [right_Inner_Boundry]
		ja ae4
		mov word [southwest], 0
		mov word [north], 1
		jmp a4
ae4:	mov word [southwest], 0
		mov word [northwest], 1
		jmp a4
aw4:	mov word [southwest], 0
		mov word [northwest], 1
		
a4:		call subroutine_Sound
	skip4:
		mov cx, [ball_attribute]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and dx , cx
		cmp dx, 0
		je skipp4
		mov word [southwest], 0
		mov word [northwest], 1
		call subroutine_Clear_Brick
		jmp agay
	skipp4:
		dec ax ;col 
		inc bx ;row
		jmp agay
nnnn:
		mov cx, [ball_attribute]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and dx , cx
		cmp dx, 0
		je c5
		mov word [north], 0
		mov word [south], 1
		call subroutine_Clear_Brick
		jmp agay
	c5:	cmp bx, 1
		jne skip5
		mov word [north], 0
		mov word [south], 1
		jmp agay
	skip5:
		dec bx

		jmp agay
		
ssss:

	c6:	cmp bx, 18
		jne skip6
		cmp ax, [right_Boundry]
		ja skip6
		cmp ax, [left_Boundry]
		jb skip6
		cmp ax, [left_Inner_Boundry]
		jb aw6
		cmp ax, [right_Inner_Boundry]
		ja ae6
		mov word [south], 0
		mov word [north], 1
		jmp a6
ae6:	mov word [south], 0
		mov word [northeast], 1
		jmp a6
aw6:	mov word [south], 0
		mov word [northwest], 1
		
a6:		call subroutine_Sound
	skip6:
		inc bx ;col 

		jmp agay
agay:
	
    mov word [ball_Column], ax
	mov word [ball_Row], bx
	call check_attrib
	mov dx , 07
	push dx                             ; pushing attribute of brick_String 
    mov dx , 1
    push dx

	push word[ball_Row]
	push word[ball_Column]
    mov dx , ball_String               ; pushing offset of brick_String
    push dx
    call subroutine_My_Print_String
	
	popa
	ret
	

timer :
    pusha
    push cs
	pop ds
	inc word[tickcount]
	inc word[second_tickcount]
	
sk1:
	cmp word[tickcount], 4
	jne sk2
	call check
	mov word[tickcount], 0
	
sk2:cmp word[second_tickcount], 18 
	jne skipall
	call subroutine_print_timer
	mov word[second_tickcount], 0
skipall:
; mov al, 0x20
; out 0x20, al 				; send EOI to PIC
 popa
; iret 						; return from interrupt
jmp far [cs : oldtimerisr]



subroutine_Clear_Brick :
pusha

call Subroutine_after__Brick_Broken

;checking for right clearance

mov ax , 0xb800
mov es , ax
cmp word [bricks_Counter], 0
jne checkRight
call subroutine_Game_Win

checkRight : 

		mov di, [ball_Index]
next5:	add di, 2
		mov ax, [es:di]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and ax , dx
		cmp ax, 0
		
		je checkLeft
		mov ax, [es:di]
		mov dx , 1000111111111111b
		and ax, dx
		mov [es:di], ax
		jmp next5


checkLeft :

		mov di, [ball_Index]
next6:	sub di, 2
		mov ax, [es:di]
		mov dx , 0111000000000000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
		and ax , dx
		cmp ax, 0
		
		je exit_subroutine_Clear_Brick
		mov ax, [es:di]
		mov dx , 1000111111111111b
		and ax, dx
		mov [es:di], ax
		jmp next6


exit_subroutine_Clear_Brick :
popa
ret

subroutine_My_Print_String :        ; this Subroutine will print the given string in the parameters

push bp 
mov bp , sp
pusha                               ; pushing all registers

mov ah, 0x13                        ; service 13 - print string
mov al, 0                           ; subservice 00 – do not update cursor
mov bh, 0                           ; output on page 0
mov bl, [bp + 12]                   ; passing attribute in bl 
mov dh , [bp + 8]                   ; passing row number 
mov dl , [bp + 6]                   ; passing column number
mov cx, [bp + 10]                   ; length of string to be printed
push cs
pop es                              ; segment of string
mov bp, [bp + 4]                    ; offset of string
int 0x10                            ; call BIOS video service

exit_subroutine_My_Print_String :   ; its an exit label for border subroutine
popa 
pop bp  
ret 10
 
subroutine_Bricks :                 ; this will print Bricks On The Screen 

push bp 
mov bp , sp
pusha
push word[row]
push word[column]
push word[attribute]
mov word[attribute] , 18
mov dx, [attribute]
mov di , 2                          ; will use to update row number and bricks will start printing from row 1
mov ax , [bp + 4]               ; offset of brick_String in ax
mov ax , [bp + 6]                   
mov [length_Brick_String] , ax      

lb :

mov cx , [number_Of_Bricks_Per_Lines]
mov word [row] , di                 ; will use to update row number and bricks will start printing from row 1
mov word [column] , 2               ; will use to update column number and bricks will start printing from column 2

la :

push dx                             ; pushing attribute of brick_String                                        
push word[length_Brick_String]      ; pushing length of string 
push word[row]
push word[column]
mov bx , brick_String               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov si , [length_Brick_String]      ; use for spaces between two bricks
add si , 3
add word [column] , si
add dx ,101                         ; updating attribute


; Note Why I am doing this step if while updating attributes at any stage it comes to stage 
; where there is black background so this will change that attribute to other colour so that 
; it display brick on screen at any colour other than black background

mov ax , 0000000001110000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
and ax , dx
jnz doNotSelfChangeAttribute
mov ax , 0000000001110000b          ; changing attribute if 3 bits representing background Colour are zero if so than change attribute 
or dx , ax

doNotSelfChangeAttribute :
loop la

add di , 2                          ; updating row number and adding two because of differentiating between two bricks by skipping one row 
sub word [number_Of_Bricks_Lines] , 1 ; Will Print On Given Number of lines in the number_Of_Bricks_Lines variable
jnz lb

exit_Subroutine_Bricks :
pop word[attribute] 
pop word[column]
pop word[row]
popa
pop bp
ret	4

; subroutine to calculate the length of a string
; takes the segment and offset of a string as parameters
strlen: 
push bp
mov bp,sp
push es
push cx
push di
push cs
pop es

mov di, [bp+4]                         ; point es:di to string
mov cx, 0xffff                         ; load maximum number in cx
xor al, al                             ; load a zero in al
repne scasb                            ; find zero in the string
mov ax, 0xffff                         ; load maximum number in ax
sub ax, cx                             ; find change in cx
dec ax                                 ; exclude null from length
pop di
pop cx
pop es
pop bp
ret 2
 
 
; not pushed or poped [column], [attribute] , [flag] 
kbisr :                             ; keyboard interrupt service routine  
       
pusha                               ; pushing all registers
push word[row]


; push cs
; pop ds


cmp byte[flag] , 1
je skip9 
add word[column] , 1
mov word[row], 20

mov ax , 0x90                       ; pushing attribute for the string                      
push ax
mov ax , bar_String       
push ax
call strlen                             
push ax                             ; pushing length of string 
push word[row]
push word[column]
mov bx , bar_String
push bx
call subroutine_My_Print_String
mov byte[flag] , 1
jmp near exit_kbisr

skip9 : 
in al, 0x60                         ; read a char from keyboard port
cmp al, 0x4d                        ; is the right key pressed
je forward
cmp al , 0x4b
jne near exit_kbisr

backward :
cmp word[column] , 1
jle exit_kbisr
push word[column]
call subroutine_Clear_Previous_Bar 
sub word[column] , 1
dec word[left_Boundry]
dec word[right_Boundry]
dec word[right_Inner_Boundry] 
dec word[left_Inner_Boundry]
jmp proceedMovement

forward :
cmp word[column] , 67
jge exit_kbisr 
push word[column]
call subroutine_Clear_Previous_Bar
inc word[left_Boundry]
inc word[right_Boundry]
inc word[right_Inner_Boundry] 
inc word[left_Inner_Boundry] 
add word[column] , 1


proceedMovement :   

add word[attribute] , 101
mov bx , 0000000001110000b          ; checking if 3 bits representing background Colour are zero if so than change attribute          
and bx , [attribute]
jnz label_C
mov bx , 0000000001110000b          ; changing attribute if 3 bits representing background Colour are zero if so than change attribute 
or [attribute] , bx


label_C : 
mov ax , [attribute]                       ; pushing attribute for the string                      
;continue : 
push ax
mov ax , bar_String       
push ax
call strlen                             
push ax                             ; pushing length of string 
push word[row]
push word[column]
mov bx , bar_String
push bx
call subroutine_My_Print_String


exit_kbisr :                          ; its an exit label for border subroutine

pop word[row]
popa 
jmp far[cs : oldisr]



subroutine_Clear_Previous_Bar :     ; not pushed or poped [row]
push bp
mov bp , sp 
pusha
mov word[row], 20
mov ax , 0x07                       ; pushing attribute for the empty_string                      
push ax
mov ax , empty_String       
push ax
call strlen                             
push ax                             ; pushing length of empty_string 
push word[row]
mov ax , [bp + 4]
push ax
mov bx , empty_String
push bx
call subroutine_My_Print_String
popa
pop bp
ret 2






subroutine_border :                    ; subroutine to make the border at the corners of the screen

pusha                                  ; pushing all registers and row and column Variables
push word[row]
push word[column]                  

;For topfirst row this will print characters on the top of the video memory

mov word [row],  2
mov word[column] ,  0
mov cx , 79                            ; will use as a loop
l1 : 

mov ax , 0x89                          ; pushing attribute of border_Character2                      
push ax
mov ax , 1                             ; pushing length of border_Character1
push ax
push word[row] 
push word[column]
mov bx , border_Character1   
push bx                                ; pushing offset of border_Character1
call subroutine_My_Print_String
add word[column] , 1
loop l1

;For last column this will print characters on the extreme right side of the video memory
mov word[column] , 79
mov word[row] , 1
mov cx , 25

l2 : 

mov ax , 0x89                          ; pushing attribute of border_Character2                      
push ax
mov ax , 1                 
push ax                                ; pushing length of border_Character2
push word[row]
push word[column]
mov bx , border_Character2
push bx                                ; pushing offset of border_Character2
call subroutine_My_Print_String
add word[row] , 1
loop l2

;For last row this will print characters on the bottom of the video memory

mov word[column] , 0
mov word[row] , 24
mov cx , 79

l3 : 
mov ax , 0x89                          ; pushing attribute of border_Character1                      
push ax 
mov ax , 1                  
push ax                                ; pushing length of border_Character1
push word[row]
push word[column]
mov bx , border_Character1
push bx                                ; pushing offset of border_Character1
call subroutine_My_Print_String
add word[column] , 1
loop l3


;For first column this will print characters on the extreme left of the video memory

mov word[column] , 0
mov word[row] , 1
mov cx , 25

l4 : 
mov ax, 0x89                           ; pushing attribute of border_Character2                      
push ax
mov ax , 1                             ; pushing length of border_Character2                      
push ax                                ; pushing length of border_Character2 
push word[row]
push word[column]
mov bx , border_Character2
push bx                                ; pushing offset of border_Character2
call subroutine_My_Print_String
add word[row] , 1
loop l4


exit_subroutine_Border :               ; its an exit label for border subroutine
pop word[column]
pop word[row]
popa 
ret
subroutine_clrscr:                     ; subroutine to clear the screen

pusha
mov ax, 0xb800
mov es, ax                             ; point es to video base
xor di, di                             ; point di to top left column
mov ax, 0x0720                         ; space char in normal attribute
mov cx, 2000                           ; number of screen locations
cld                                    ; auto increment mode
rep stosw                              ; clear the whole screen

exit_subroutine_clrscr : 
popa
ret

subroutine_startUp :
pusha
push word[row]
push word[column]
push word[flag1] 
push word[counter]
push word[attribute]

mov word[flag1] , 0
mov word[counter] , 3
mov word[attribute] , 0xd0

printAgain : 
;mov cx  , 3000
;lz :
call subroutine_Sound 
cmp word[flag1] , 2
je near print_One

mov word[row] , 6
mov word[column] ,30 
push word[attribute]                             ; pushing attribute of brick_String 
mov ax , startUp_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUp_String               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov si , 7
mov word[row] , 6
again5 :

mov word[column] , 45
push word[attribute]                             ; pushing attribute of brick_String 
mov ax , startUpcharacter_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUpcharacter_String              ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
add word[row] , 1
sub si , 1
jnz again5

mov word[row] , 12
mov word[column] ,30 
push word[attribute]                              ; pushing attribute of brick_String 
mov ax , startUp_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUp_String               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

mov word[row] , 18
mov word[column] ,30 
push word[attribute]                              ; pushing attribute of brick_String                             ; pushing attribute of brick_String 
mov ax , startUp_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUp_String               ; pushing offset of brick_String
push bx
call subroutine_My_Print_String

cmp word[flag1] , 1
jz print_Two
mov si , 6
mov word[row] , 13
again6 :

mov word[column] , 45
push word[attribute]                             ; pushing attribute of brick_String 
mov ax , startUpcharacter_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUpcharacter_String              ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
add word[row] , 1
sub si , 1
jnz again6

cmp word[flag1] , 0
jz near donot_Print
print_Two :
mov si , 6
mov word[row] , 13
again7 :

mov word[column] , 30
push word[attribute]                            ; pushing attribute of brick_String 
mov ax , startUpcharacter_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUpcharacter_String              ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
add word[row] , 1
sub si , 1
jnz again7

cmp word[flag1] , 2
jne donot_Print
print_One : 
mov si , 11
mov word[row] , 7
again8 :

mov word[column] , 40
push word[attribute]                            ; pushing attribute of brick_String 
mov ax , startUpcharacter_String
push ax
call strlen      
push ax                             ; pushing length of string                                                         
push word[row]
push word[column]
mov bx , startUpcharacter_String              ; pushing offset of brick_String
push bx
call subroutine_My_Print_String
add word[row] , 1
sub si , 1
jnz again8

donot_Print :
mov cx , 1500
mov dx , 1500

emptyOuterLoop :
mov dx , 1500
emptyInnerLoop :
dec dx
jnz emptyInnerLoop
dec cx
jnz emptyOuterLoop

add word[flag1] , 1
call subroutine_clrscr
add word[attribute] , 100
dec word[counter] 
jnz near printAgain

exit_startUp : 
pop word[attribute]
pop word[counter]
pop word[flag1] 
pop word[column]
pop word[row]
popa
ret

subroutine_Sound :
pusha 
mov     al, 182         ; Prepare the speaker for the
out     43h, al         ;  note.
mov     ax, 7400       ; Frequency number (in decimal) for middle C.
out     42h, al         ; Output low byte.
mov     al, ah          ; Output high byte.
out     42h, al 
in      al, 61h         ; Turn on note (get value from port 61h).
or      al, 00000011b   ; Set bits 1 and 0.
out     61h, al         ; Send new value.
mov     bx, 5           ; Pause for duration of note.
label_E:
mov     cx, 65535
label_d : 
dec     cx
jne     label_d
dec     bx
jne     label_E
in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
and     al, 11111100b   ; Reset bits 1 and 0.
out     61h, al         ; Send new value.
popa
ret

subroutine_Date :         ; it will generate a random number with the help of our system time
pusha
mov ah, 2ah
int 21h 
 
mov bx , cx               ; saving years value in bx
mov ax , 0xb800
mov es  , ax

; Printing Month 
mov al , dh
mov ah , 0
mov cl , 10
div cl
mov cl , al
add cl , 0x30
mov ch , 0x0A
mov word[es : 3976] , cx 
mov cl  , ah
add cl , 0x30
mov ch , 0x0A

mov word[es : 3978] , cx
; mov ch , 07
; mov cl , ' ' 
; mov word[es : 3984] , cx 
mov ch ,0x0A
mov cl , '/' 
mov word[es : 3980] , cx 
; mov ch , 07
; mov cl , ' ' 
; mov word[es : 3976] , cx

; Priting Day Of The Month
mov al , dl
mov ah , 0
mov cl , 10
div cl
mov cl , al
add cl , 0x30
mov ch , 0x0A
mov word[es : 3982] , cx 
mov cl  , ah
add cl , 0x30
mov ch , 0x0A

mov word[es : 3984] , cx
; mov ch , 07
; mov cl , ' ' 
; mov word[es : 3988] , cx 
mov ch , 0x0A
mov cl , '/' 
mov word[es : 3986] , cx 
; mov ch , 07
; mov cl , ' ' 
; mov word[es : 3986] , cx

; printing Year
mov ax , bx
mov dx , 0
mov cx , 10
div cx
mov dh , 0x0A
add dl , 0x30
mov word[es : 3994] , dx
 

mov cl , 10
div cl 
mov dl , ah
add dl , 0x30
mov dh , 0x0A
mov word[es : 3992] , dx

mov ah , 0
mov cl , 10
div cl 
mov dl , ah
add dl , 0x30
mov dh , 0x0A
mov word[es : 3990] , dx

mov ah , 0
mov cl , 10
div cl 
mov dl , ah
add dl , 0x30
mov dh , 0x0A
mov word[es : 3988] , dx

popa   
ret 

main :

call subroutine_clrscr               
call subroutine_Menu              
call subroutine_Date
call subroutine_border   
call subroutine_State
; mov ax , 0xb800
; mov es , ax
; mov bx , 3626
; push bx
; push word[bricks_Counter] 
; call subroutine_Print_Score

mov ax , 3534 
push ax
push word[score]
call subroutine_Print_Score
mov ax , 3556
push ax
push word[life]
call subroutine_Print_Score

xor ax, ax
mov es, ax                             ; point es to ivt base
mov ax, [es:9*4]
mov [oldisr], ax                       ; save offset of old routine
mov ax, [es:9*4+2]
mov [oldisr+2], ax                     ; save segment of old routine


mov ax, [es:8*4]
mov [oldtimerisr], ax                       ; save offset of old routine
mov ax, [es:8*4+2]
mov [oldtimerisr+2], ax                     ; save segment of old routine
cli                                    ; disable interrupts
mov word [es:9*4], kbisr               ; store offset at n*4
mov [es:9*4+2], cs                     ; store segment at n*4+2

mov word [es:8*4], timer               ; store offset at n*4
mov [es:8*4+2], cs                     ; store segment at n*4+2

sti                                    ; enable interrupts


exit_Main :
 mov dx, main                         ; end of resident portion
 add dx, 15                           ; round up to next para
 mov cl, 4
 shr dx, cl                           ; number of paras
 mov ax, 0x3100                       ; terminate and stay resident
 int 0x21

;mov ax, 0x4c00                         ; terminate and stay resident
;int 0x21