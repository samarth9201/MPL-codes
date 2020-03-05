section .data
fname: db "abc.txt",0
msg1: db "String is : ",0x0A
len1: equ $-msg1
msg2: db "Reverse is : ",0x0A
len2: equ $-msg2
msg3: db "String is Palindrome",0x0A
len3: equ $-msg3
msg4: db "String is not Palindrome",0x0A
len4: equ $-msg4
val: db 10

section .bss
character: resb 2
fd: resb 10
buffer: resb 1000
len: resb 10
cnt: resb 10
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

scall 2,fname,2,0777

mov qword[fd],rax

scall 0,[fd],buffer,1000

mov qword[len],rax
mov qword[cnt],rax


PrintString:

scall 1,1,msg1,len1
scall 1,1,buffer,len
scall 1,1,msg2,len2

mov rsi,buffer
sub qword[cnt],1
sub qword[len],1

loop1:
inc rsi
dec qword[cnt]
jnz loop1

dec rsi

mov rax,qword[len]
mov qword[cnt],rax

loop:

mov al,byte[rsi]
mov byte[character],al
push rsi
scall 1,1,character,1
pop rsi
dec rsi
dec qword[cnt]

jnz loop

scall 1,1,val,1

mov rsi,buffer
mov rdi,buffer

mov rax,qword[len]
mov qword[cnt],rax

loop2:
inc rsi
dec qword[cnt]
jnz loop2

dec rsi

mov rax,qword[len]
mov qword[cnt],rax

loop3:

mov al,byte[rsi]
mov bl,byte[rdi]
cmp bl,al
jne NotPalindrome
inc rdi
dec rsi
dec qword[cnt]

jnz loop3

scall 1,1,msg3,len3
scall 1,1,val,1
jmp exit

NotPalindrome:

scall 1,1,msg4,len4
scall 1,1,val,1

exit:
mov rax,60
mov rdi,0
syscall
