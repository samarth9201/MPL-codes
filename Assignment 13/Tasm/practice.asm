.model tiny
.286
org 100H

Code Segement
Assume CS:Code,DS: Code,EP: Code
old_ip dw 00
old_cs dw 00

jmp init

init:

mov ax,cs
mov ds,ax

cli

mov ah,35H
mov al,08H
int 21H

mov old_cs,bx
mov old_ip,es

mov ah,25H
mov al,08H
lea dx,my_tsr
int 21H

mov ah,31H
mov dx,offset init
sti

int 21H

code ends

end