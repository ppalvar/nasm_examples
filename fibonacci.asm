;Algoritmo: fibonacci iterativo

%include "io.inc"

section .data
    n dd 10
    

section .bss
    st resb 2
    ans resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov eax, 1;store 1 in eax and ebx 'cause fib(0) = fib(1) = 1
    mov ebx, 1
    
    mov ecx, [n];pick the number from the memory
    
    .fib:        
        add eax, ebx;add together the last two fibonacci numbers
        
        xchg ebx, eax;swap them
        
        dec ecx;decrease the loop counter
        cmp ecx, 0
        je .end;go to the end if the counter is zero
        
        jmp .fib;else go back to the beginning of the loop
        
    .end:
    
    PRINT_DEC 1, eax 
    
    xor eax, eax
    ret