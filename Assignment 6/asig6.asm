section .data
msg1: db "GDTR : "
l1: equ $-msg1
msg2: db "IDTR : "
l2: equ $-msg2
msg3: db "LDTR : "
l3: equ $-msg3
msg4: db "TR : "
l4: equ $-msg4
msg5: db "MSW : "
l5: equ $-msg5
val: db 10
cnt: db 00

section .bss
ldtr: resb 2
tr: resb 2
msw: resb 4
mem: resb 6
result: resb 8
%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text

scall 1,1,msg1,l1

sgdt [mem]
call display48

scall 1,1,val,1

scall 1,1,msg3,l3

sldt [ldtr]
mov dx,word[ldtr]
call htoA

scall 1,1,val,1

scall 1,1,msg2,l2

sidt [mem]
call display48

scall 1,1,val,1


scall 1,1,msg4,l4

str [tr]
mov dx,word[tr]
call htoA

scall 1,1,val,1

scall 1,1,msg5,l5

smsw [msw]
mov dx,word[msw+2]
call htoA
mov dx,word[msw]
call htoA

scall 1,1,val,1

mov rax,60
mov rdi,0
syscall





display48:

mov dx,word[mem+4]
call htoA
mov dx,word[mem+2]
call htoA
mov dx,word[mem]
call htoA

ret




htoA:
mov rsi,result
mov byte[cnt],4
up:
rol dx,04
mov cl,dl
and cl,0FH
cmp cl,09
jbe next
add cl,07H
next:
add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[cnt]
jnz up

scall 1,1,result,4

ret

