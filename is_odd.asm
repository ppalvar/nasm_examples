;Este no lo voy a comentar :(
%include "io.inc"

section .data
    n dd 1002

section .bss
    ans resb 2

section .text
global CMAIN
CMAIN:
    mov eax, [n]
    
    inc eax
            
    and eax, 1
    add al, '0'
    
    mov ebx, ans
    mov [ebx], al
    inc ebx
    mov cl, 0
    mov [ebx], cl
    
    PRINT_STRING ans
    
    xor eax, eax
    ret