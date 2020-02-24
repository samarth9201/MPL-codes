section .data
array: dq 0xF23456789ABCDEF0,0xA23456789ABCDEF0,0x823456789ABCDEF0,0x1234506789ABCDEF,0x1230456789ABCDEF,0x1234056789ABCDEF,0x1023456789ABCDEF,0x1234056789ABCDEF,0x1203456789ABCDEF,0xF230456789ABCDEF
pos: db 0
neg: db 0
count: db 10
msg1: db "Positive : ",0x0A
l1: equ $-msg1
msg2: db "Negative : ",0x0A
l2: equ $-msg2
val: db 10

;if 0x123456789ABCDEF is number it is stored in memory like this: 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111 MSB is 0 so number is positive
;0x923456789ABCDEF: 1001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111 MSB is 1 so number is negative


section .text
global main
main:


mov rsi,array
up:
mov rax,qword[rsi]
bt rax,63
jc next		;if MSB of rax is one jump occurs
inc byte[pos]	;inc pos if MSB is zero
jmp up2
next:
inc byte[neg]	;increment neg if MSB of rax is one
up2:
add rsi,8	;rsi points towards next element
dec byte[count]
jnz up 		;if count is not zero jump occurs

cmp byte[pos],09H
jbe label1
add byte[pos],07H
label1:
add byte[pos],30H

cmp byte[neg],09H
jbe label2
add byte[neg],07H
label2:
add byte[neg],30H

mov rax,1	;write system call
mov rdi,1
mov rsi,msg1
mov rdx,l1
syscall

mov rax,1	;write system call
mov rdi,1
mov rsi,pos
mov rdx,1
syscall

mov rax,1	;write system call
mov rdi,1
mov rsi,val
mov rdx,1
syscall

mov rax,1	;write system call
mov rdi,1
mov rsi,msg2
mov rdx,l2
syscall

mov rax,1	;write system call
mov rdi,1
mov rsi,neg
mov rdx,1
syscall

mov rax,1	;write system call
mov rdi,1
mov rsi,val
mov rdx,1
syscall

mov rax,60	;exit system call
mov rdi,0
syscall
