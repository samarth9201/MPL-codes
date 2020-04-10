section .data
arr: dd 101.11,102.22,103.33,104.44,105.55
cnt: dw 5
cnt2: dw 5
cnt3: dw 9
dec: dw 100
dot: db "."
val: db 10
msg1: db "Mean",0x0A
len1: equ $-msg1
msg2: db "Variance",0x0A
len2: equ $-msg2
msg3: db "Standard Deviation",0x0A
len3: equ $-msg3

section .bss
buffer: resb 20
mean: resb 10
var: resb 10
sd: resb 10
result: resb 10
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

finit

fldz
mov rsi,arr
mov byte[cnt2],5

up:
fadd dword[rsi]
add rsi,4
dec byte[cnt2]
jnz up

fidiv word[cnt]

fst dword[mean]
mov rax,qword[mean]
mov qword[buffer],rax
scall 1,1,msg1,len1
call print
scall 1,1,val,1

mov rsi,arr
mov byte[cnt2],5
fldz

up2:
fldz
fadd dword[rsi]
fsub dword[mean]
fmul st0
fadd

add rsi,4
dec byte[cnt2]

jnz up2

fidiv word[cnt]

fst dword[var]
mov rax,qword[var]
mov qword[buffer],rax
scall 1,1,msg2,len2
call print
scall 1,1,val,1

fldz
fld dword[var]
fsqrt
fst dword[sd]
mov rax,qword[sd]
mov qword[buffer],rax
scall 1,1,msg3,len3
call print
scall 1,1,val,1

mov rax,60
mov rdi,0
syscall

print:

fimul word[dec]
fbstp [buffer]
mov rsi,buffer+9
mov byte[cnt3],9

loop:
mov dl,byte[rsi]
push rsi
call HtoA
pop rsi
dec rsi
dec byte[cnt3]
jnz loop

scall 1,1,dot,1

mov dl,byte[buffer]
call HtoA

ret

HtoA:

mov rsi,result		;address of result is stored in rsi
mov byte[cnt2],2	;we are converting qword to ascii so counter is set to 2
up4:
rol dl,4
mov cl,dl
and cl,0FH
cmp cl,09
jbe next2
add cl,07H
next2:
add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[cnt2]
jnz up4

mov rax,1
mov rdi,1
mov rsi,result
mov rdx,2
syscall

ret
