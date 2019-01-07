# Assembly_x86
How to Run
1- Download this code and move the 'assembly_code' folder to C: directory.

2- Install DOSBOX from this link: Download DOSBOX Emulator

3- After complete installation, go to DOSBOX installation directory and run "DOSBox 0.74 Options.bat". This will save you from the pain of searching the configuration file yourself and will open that file for you. Copy these lines at the end of that file:

mount c: c:\assembly_code 
c:
4- Now to run any question (say named 'q1.asm'), run DOSBOX 0.74 and type

nasm q1.asm -o q1.com  
To run the code, type:

q1.com
To examine step by step working of the code, type

afd q1.com
