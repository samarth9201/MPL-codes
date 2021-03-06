section .data
msg: db "1.Successive Addition",0x0A
     db "2.Add and Shift Method",0x0A
     db "3.Exit",0x0A
len: equ $- msg
msg1: db "Enter Number",0x0A
l1: equ $-msg1
val: db 10
cnt: db 00
cnt2: db 00

section .bss
choice: resb 2
num1: resb 3
num2: resb 3
num: resb 2
prod: resb 4
result: resb 8
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

scall 1,1,msg,len
scall 0,1,choice,2

cmp byte[choice],31H
je first

cmp byte[choice],32H
je second

cmp byte[choice],33H
je exit

exit:
mov rax,60
mov rdi,0
syscall

first:
call SA
jmp main

second:
call AandShift
jmp main

SA:
scall 1,1,msg1,l1
scall 0,1,num1,3

scall 1,1,msg1,l1
scall 0,1,num2,3

mov ax,word[num1]
mov word[num],ax
call AtoHex

mov word[num1],bx

mov ax,word[num2]
mov word[num],ax
call AtoHex

mov word[cnt],bx
mov rax,00

loop1:
add ax,word[num1]
dec byte[cnt]
jnz loop1

mov rdx,rax
call HtoA

ret

AandShift:
scall 1,1,msg1,l1
scall 0,1,num1,3

scall 1,1,msg1,l1
scall 0,1,num2,3

mov ax,word[num1]
mov word[num],ax
call AtoHex

mov word[num1],bx

mov ax,word[num2]
mov word[num],ax
call AtoHex

mov word[num2],bx

mov ax,word[num1]
mov bx,word[num2]
mov rcx,00
mov byte[cnt],8

loop2:
shr bx,01
jc down
jnc down2

down:
add cx,ax
shl ax,01
jmp decCounter

down2:
shl ax,01
jmp decCounter

decCounter:
dec byte[cnt]
jnz loop2

mov rdx,rcx
call HtoA

ret

AtoHex:


mov rsi,num
mov byte[cnt],2
mov bx,00
up:
rol bx,04
mov dl,byte[rsi]
cmp dl,39H
jbe next3
sub dl,07H
next3:
sub dl,30H
add bl,dl
inc rsi
dec byte[cnt]
jnz up

ret

HtoA:
mov rsi,result
mov byte[cnt2],4
up2:
rol dx,04
mov cl,dl
and cl,0FH
cmp cl,09H
jbe next4
add cl,07H
next4: add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[cnt2]
jnz up2

scall 1,1,result,4
scall 1,1,val,1
ret
