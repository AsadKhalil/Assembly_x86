# Assembly_x86
How to Run
1- Download this code and move the 'assembly_code' folder to C: directory.

2- Unrar the DOSBOX file from given rar file

3- place DosBox Folder,nasm file ,afd file and cwsdpmi file in 'assembly_code' folder  C: directory.

open DOS BOXPORTABLE application file

write

mount c: c:\assembly_code 
c:

4- Now to run any question (say named 'q1.asm'), run DOSBOX 0.74 and type

nasm q1.asm -o q1.com  
To run the code, type:

q1.com
To examine step by step working of the code, type

afd q1.com
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#CODE NAMES
///////////////////////////////////////////////////////////////////////////////////////////////////////////
1: This subroutine finds if a set of consecutive n number of zeros is present in the given sequence or not
2: KERNAL
3: This function is used calculate the length of the string  strlen: order of pushing parameters: segment and offset length is returned in ax
4:  Asteric
5: Clear screen
6: Fibonachi
7: Gcd
8: Gcdr
9: Invert
10: Printscreen
11: Swap screen
12: Invert screen
13: MY SCREEN SAVER
 You have to write a TSR for a Screen saver and hook it with the timer interrupt. If your computer has been idle (NO KEYBOARD INTERRUPT) for 10 seconds, the timer would cause the screen saver to run. Your screen saver would be the text “MY SCREEN SAVER”, being displayed in the middle of the screen. For as long as the screen saver is running, this text would change its color every second. Now, modify your program so that as soon as a keyboard interrupt occurs, it restores whatever previously was on the screen.
Hint: Before displaying the screen saver, you have to backup everything that is being displayed on the screen. 
14: subroutine to print a number at top left of screen hex
15:  keyboard interrupt service routine .. timer interrupt service routine 
16: subroutine to print a number at the specificed location of the screen  order of parameters: location, number
17: ifferentiate left and right shift keys with scancodes. keyboard interrupt service routine
18: shift key
19: single step interrupt service routine
20: wait key
21: add
22: mul
23: neg xor
24: mytask subroutine to be run as a thread. takes line number as parameter(time)
25: subroutine to print a number on screen takes the row no, column no, and number to be printed as parameters
26: factorial
27: direction of rotation	- 0 for left & 1 for right
28: re-arrange the elements. The program will sort it in descending order itself
29: this function will pack the given data into the required format and return the output in the ax register
encode: order of pushing data: day, month, year
30: flip
31: multitasking and dynamic thread registration
32: subroutine to print a number on screen takes the row no, column no, and number to be printed as parameters
33: Code for sorting the array in descending order
34: link list 
35: takes the number of lines to be scrolldown
36: this function takes the number of lines to be scrolled up as a parameter
37: fins substring
38: Evaluate Binomial at 2 points
39: check number wether it is prime or not if it is then evaluate previous prime number
40: multitasking, delete task after its completion
41: muultitasking 
42 : multitasking , stops task with timer
43:charcter Raining
44: Multitasking with colors
