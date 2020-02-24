section .data
msg1: db "Enter first Number :",0x0A
l1: equ $-msg1
msg2: db "Enter second number :",0x0A
l2: equ $-msg2

section .bss
result: resb 2
a: resb 2
b: resb 2
%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global main 
main:
scall 1,1,msg1,l1
scall 0,1,a,2
scall 1,1,msg2,l2
scall 0,1,b,2

cmp byte[a],39H
jbe next
sub byte[a],07H
next:
sub byte[a],30H

cmp byte[b],39H
jbe next2
sub byte[a],07H
next2:
sub byte[a],30H

mov al,byte[a]
mov bl,byte[b]
add al,bl
mov byte[result],al

cmp byte[result],9
jbe next3
add byte[result],07H
next3:
add byte[result],30H

scall 1,1,result,2

mov rax,60
mov rdi,0
syscall

