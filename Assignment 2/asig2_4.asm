section .data
msg1: db "Original Array : ",0x0A
l1: equ $-msg1
msg2: db " : "
l2: equ $-msg2
msg3: db "Final Array : ",0x0A
l3: equ $-msg3
val : db 10
cnt: db 5
cnt2: db 16
array: dq 0x1023456789ABCDEF,0x5023456789ABCDEF,0x60D3456789ABCDEF,0x8023456789ABCDEF,0xA023456789ABCDEF,0,0,0,0,0
array2: dq 0,0,0,0,0

;Overlapping with string functions


section .bss
result : resb 16

section .text
global main
main:

mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,l1
syscall

mov rsi,array

call print

mov rax,1
mov rdi,1
mov rsi,msg3
mov rdx,l3
syscall

mov byte[cnt],5
mov rsi,array	;address of array is stored at rsi
mov rdi,array2

call copy

mov byte[cnt],5
mov rsi,array2
mov rdi,array+24

call copy



mov rsi,array
mov byte[cnt],8

call print

mov rax,60	;exit syscall
mov rsi,1
syscall

hToA:
mov rsi,result		;address of result is stored in rsi
mov byte[cnt2],16	;we are converting qword to ascii so counter is set to 16
up2:
rol rdx,4		;rol is rotate left by 4 bits
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
jnz up2

mov rax,1
mov rdi,1
mov rsi,result
mov rdx,16
syscall

ret
print:

mov rdx,rsi
push rsi	;contents of rsi are pushed to stack because after call to hToA and syscall, contents of rsi will change
call hToA	;hToA is called, this will convert hex valu to Ascii, here(in this call) address of element is printed 

mov rax,1	;" : " is printed
mov rdi,1
mov rsi,msg2
mov rdx,l2
syscall

pop rsi		;contents of stack are poped to retreive contents of rsi befor call to hToA and syscall
mov rdx,qword[rsi]	;contents of rsi i.e value at address stored at rsi is moved to rdx
push rsi	;contents of rsi are pushed to stack
call hToA	;in this call value of element is printed

mov rax,1	;syscall for newline
mov rdi,1
mov rsi,val
mov rdx,1
syscall

pop rsi		;contents of rsi are poped

add rsi,8	;rsi is incremented by 8 as we have used qword
dec byte[cnt]	;byte is decremented
jnz print		;jump until byte[cnt] is not zero

ret

copy:		;this loop copies contents of rsi to rdi
mov rcx,5
cld
rep movsq

ret

