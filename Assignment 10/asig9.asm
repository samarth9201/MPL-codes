section .data
ff1: db "%lf + i %lf",10,0
ff2: db "%lf - i %lf",10,0
formatpi: db "%d",10,0
formatpf: db "%lf",10,0
formatsf: db "%lf",0
four: dw 4
two: dq 2
msg1: db "Root 1 : " ,0x0A
len1: equ $-msg1
msg2: db "Root 2 : ",0x0A
len2: equ $-msg2
msg3: db "Enter 'a' (co-efficient of x^2) : ",0x0A
len3: equ $-msg3
msg4: db "Enter 'b' (co-efficient of x) : ",0x0A
len4: equ $-msg4
msg5: db "Enter 'c' (constant) : ",0x0A
len5: equ $-msg5


section .bss

a: resb 10
b: resb 10
c: resb 10
bsqr: resb 10
ac: resb 10
ac4: resb 10
a2: resb 10
det: resb 10
detsqrt: resb 10
root1: resb 10
root2: resb 10
real: resb 10
img: resb 10

%macro myprintf 1
mov rdi,formatpf
sub rsp,8
movsd xmm0,[%1]
mov rax,1
call printf
add rsp,8
%endmacro

%macro myscanf 1
mov rdi,formatsf
mov rax,0
sub rsp,8
mov rsi,rsp
call scanf
mov r8,qword[rsp]
mov [%1],r8
add rsp,8
%endmacro

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

extern printf,scanf

scall 1,1,msg3,len3
myscanf a
scall 1,1,msg4,len4
myscanf b
scall 1,1,msg5,len5
myscanf c

finit

;Calculate b^2

fldz
fadd qword[b]
fmul st0
fstp qword[bsqr]


;Calculate 4ac

fldz
fadd qword[a]
fmul qword[c]
fstp qword[ac]

fldz
fadd qword[ac]
fadd qword[ac]
fadd qword[ac]
fadd qword[ac]

fst qword[ac4]

;Calculate 2a

fldz
fadd qword[a]
fadd qword[a]
fst qword[a2]

;Calculate determinant

fldz
fadd qword[bsqr]
fsub qword[ac4]
fstp qword[det]

;check if Determinant is negative

bt qword[det],63
;if carry flag is set jump to imaginary else roots are real
jc imaginary

;calculate squareroot of det

fldz
fadd qword[det]
fsqrt
fstp qword[detsqrt]

;calculating roots

fldz
fsub qword[b]
fadd qword[detsqrt]
fdiv qword[a2]
fstp qword[root1]

fldz
fsub qword[b]
fsub qword[detsqrt]
fdiv qword[a2]
fstp qword[root2]

scall 1,1,msg1,len1
myprintf root1
scall 1,1,msg2,len2
myprintf root2

mov rax,60
mov rdi,0
syscall

imaginary:

fldz
fsub qword[det]
fsqrt
fstp qword[detsqrt]


;calculate real part

fldz
fsub qword[b]
fdiv qword[a2]
fstp qword[real]


;calculate imaginary part

fldz
fadd qword[detsqrt]
fdiv qword[a2]
fstp qword[img]


;Printing first root : real + i img
scall 1,1,msg1,len1
mov rdi,ff1
sub rsp,8
movsd xmm0,[real]
movsd xmm1,[img]
mov rax,2
call printf
add rsp,8

;Printing second root : real - i img
scall 1,1,msg2,len2
mov rdi,ff2
sub rsp,8
movsd xmm0,[real]
movsd xmm1,[img]
mov rax,2
call printf
add rsp,8


mov rax,60
mov rdi,0
syscall
