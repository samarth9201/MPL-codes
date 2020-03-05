section .data
msg1: db "GDTR : ",0x0A
len1: equ $-msg1
msg2: db "LDTR : ",0x0A
len2: equ $-msg2
msg3: db "IDTR :",0x0A
len3: equ $-msg3
msg4: db "MSW :",0x0A
len4: equ $-msg4
msg5: db "You are in protected mode",0x0A
len5: equ $-msg5
msg6: db "You are not in protected mode",0x0A
len6: equ $-msg6
msg7: db "Coprocessor is present",0x0A
len7: equ $-msg7
msg8: db "Coprocessor is not present",0x0A
len8: equ $-msg8
msg9: db "Coprocessor present is 80287",0x0A
len9: equ $-msg9
msg10: db "Coprocessor present is 80387",0x0A
len10: equ $-msg10
msg11: db "TR :",0x0A
len11: equ $-msg11 
val: db 10
cnt2: db 00


section .bss
mem: resb 6
mem2: resb 4
tr: resb 4
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

scall 1,1,msg1,len1
mov rax,00

sgdt [mem]
mov rdx,00
mov dx,word[mem+4]
call HtoA
mov rdx,00
mov dx,word[mem+2]
call HtoA
mov rdx,00
mov dx,word[mem]
call HtoA

scall 1,1,val,1

scall 1,1,msg3,len3

sidt [mem]
mov rdx,00
mov dx,word[mem+4]
call HtoA
mov rdx,00
mov dx,word[mem+2]
call HtoA
mov rdx,00
mov dx,word[mem]
call HtoA

scall 1,1,val,1

scall 1,1,msg2,len2

sldt [mem2]
mov rdx,00
mov dx,word[mem2]
call HtoA

scall 1,1,val,1

scall 1,1,msg11,len11

str [tr]
mov dx,word[tr]
call HtoA

scall 1,1,val,1

scall 1,1,msg4,len4

smsw [mem]
mov rdx,00
mov dx,word[mem]
call HtoA

scall 1,1,val,1

mov ax,word[mem]
bt rax,0
jc down
scall 1,1,msg6,len6
down:
scall 1,1,msg5,len5

mov ax,word[mem]
bt rax,1
jc down2
scall 1,1,msg8,len8
down2:
scall 1,1,msg7,len7

mov ax,word[mem]
bt rax,4
jc down3
scall 1,1,msg9,len9
down3:
scall 1,1,msg10,len10



mov rax,60
mov rdi,0
syscall

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

ret
