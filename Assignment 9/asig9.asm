section .data
msg1: db "Enter a Number : ",0x0A
len1: equ $-msg1
msg2: db "Factorial is (Non-Recursive) : ",0x0A
len2: equ $-msg2
msg3: db "Factorial is (Recursive) : ",0x0A
len3: equ $-msg3
cnt: db 2
val: db 10

section .bss
result: resb 10
num: resb 10
temp: resb 3

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

;scall 1,1,msg1,len1
;scall 0,1,num,3

pop rbx
pop rbx
pop rbx

mov rax,qword[rbx]
mov qword[num],rax

scall 1,1,num,2
;mov bx,word[num]

call AtoH

mov byte[num],bl
mov byte[temp],bl

scall 1,1,msg2,len2
call factNR

mov al,byte[temp]
mov byte[num],al
mov bl,byte[num]

scall 1,1,msg3,len3
call factR
mov edx,eax
call HtoA


mov rax,60
mov rdi,0
syscall

AtoH:

mov rsi,num
mov byte[cnt],2
mov bx,00
up:
rol bl,04
mov dl,byte[rsi]
cmp dl,39H
jbe down
sub dl,07H
down:
sub dl,30H
add bl,dl
inc rsi
dec byte[cnt]
jnz up

ret

HtoA:
mov rsi,result
mov byte[cnt],4
up10:
rol dx,04
mov cl,dl
and cl,0FH
cmp cl,09
jbe down1
add cl,07H
down1:
add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[cnt]
jnz up10

scall 1,1,result,4
scall 1,1,val,1

ret

factNR:

mov ecx,00
mov cl,byte[num]
mov rax,1

loop:

mov bx,cx
mul bx
dec cx

jnz loop

mov edx,eax
call HtoA

ret

factR:

cmp bl,01H
jne do_calc
mov ax,1
ret
do_calc:

push rbx
dec bl

call factR

pop rbx
mul bl

ret
