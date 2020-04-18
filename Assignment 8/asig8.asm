section .data
msg1: db "Enter: ",0x0A
      db "1. Type",0x0A
      db "2. Copy",0x0A
      db "3. Delete",0x0A
      db "4. Exit",0x0A
len1: equ $- msg1
msg2: db "Enter file name : ",0x0A
len2: equ $- msg2
msg3: db "File opened successfully",0x0A
len3: equ $- msg3
msg4: db "File opening failed",0x0A
len4: equ $- msg4
msg5: db "Copy Successfull",0x0A
len5: equ $- msg5
msg6: db "Delete Successfull",0x0A
len6: equ $- msg6
contentMessage: db "-------File Contents-------",0x0A
contentMessageLength: equ $- contentMessage
dashes: db "---------------------------",0x0A
dashesLength: equ $- dashes
val: db 10

section .bss
choice: resb 2
fileName: resb 20
FileDescriptor: resb 100
buffer: resb 1000
bufferLength: resb 10

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

scall 1,1,msg1,len1
scall 0,0,choice,2

cmp byte[choice],31H
je First

cmp byte[choice],32H
je Second

cmp byte[choice],33H
je Third

cmp byte[choice],34H
je exit

exit:
mov rax,60
mov rdi,1
syscall

First:

scall 1,1,msg2,len2
scall 0,0,fileName,20
dec rax
mov byte[fileName+rax],0

scall 2,fileName,2,0777
mov qword[FileDescriptor],rax
bt rax,63
jc error

scall 1,1,msg3,len3

scall 0,[FileDescriptor],buffer,1000
mov qword[bufferLength],rax

scall 1,1,contentMessage,contentMessageLength
scall 1,1,buffer,[bufferLength]
scall 1,1,val,1
scall 1,1,dashes,dashesLength

mov rax,3
mov rdi,fileName
syscall

jmp main

Second:

scall 1,1,msg2,len2
scall 0,0,fileName,20
dec rax
mov byte[fileName+rax],0

scall 2,fileName,2,0777
mov qword[FileDescriptor],rax
bt rax,63
jc error

scall 1,1,msg3,len3
scall 0,[FileDescriptor],buffer,1000
mov qword[bufferLength],rax

mov rax,3
mov rdi,fileName
syscall

scall 1,1,msg2,len2
scall 0,0,fileName,20
dec rax
mov byte[fileName+rax],0

scall 2,fileName,2,0777
mov qword[FileDescriptor],rax
bt rax,63
jc error

scall 1,[FileDescriptor],buffer,[bufferLength]

mov rax,3
mov rdi,fileName
syscall

scall 1,1,msg5,len5

jmp main

Third:

scall 1,1,msg2,len2
scall 0,0,fileName,20

dec rax
mov byte[fileName+rax],0
mov rax,87
mov rdi,fileName
syscall

scall 1,1,msg6,len6

jmp main

error:
scall 1,1,msg4,len4
jmp main