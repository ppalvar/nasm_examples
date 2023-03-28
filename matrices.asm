; Implementacion de matrices
; matriz = guarda el punto de inicio de la matriz
; w = ancho de la matriz
; h = altura de la matriz

%include "io64.inc"

section .data
    matriz dq 0
    w dq 0
    h dq 0

section .text
    global CMAIN

CMAIN:
    mov rbp, rsp; for correct debugging
    mov rdi, rbp
    
    ;-----CREATE MATRIZ 1-----;
    GET_UDEC 4, h
    GET_UDEC 4, w
    
    mov qword[matriz], rsp
    mov ebx, 0
    
    .L1:
        cmp ebx, [w]
        je .BREAK
        
        inc ebx
        mov ecx, [h]
        
        .L2:
            GET_DEC 8, rax
            push rax
            
            loop .L2 
        
        jmp .L1
        
        .BREAK:
            mov rbp, rsp
    ;-------------------------;
        
    mov rax, 5
    call mult_for_scalar
    
    call print
    
    mov rsp, rdi
    mov rbp, rdi
    xor eax, eax
    ret

mult_for_scalar:
    push rbp
    mov rbp, rsp
    
    push rax
    
    mov rsi, qword[matriz]
    sub rsi, 8
    mov ebx, 0
    
    .LP1:
        cmp ebx, [h]
        je exit
        
        inc ebx
        mov ecx, 0
        
        .LP2:
            xor rdx, rdx 
            mov rax, [rsp]
            mul qword[rsi]
            mov [rsi], rax
            
            sub rsi, 8
            inc ecx
            
            cmp ecx, [w]
            jne .LP2
        
        jmp .LP1
                
print:
    push rbp
    mov rbp, rsp
    
    mov rsi, qword[matriz]
    sub rsi, 8
    mov ebx, 0
    
    .LP1:
        cmp ebx, [h]
        je exit
        
        inc ebx
        mov edx, 0
        
        .LP2:
            PRINT_DEC 8, [rsi]
            PRINT_STRING " "
            
            sub rsi, 8
            inc edx
            
            cmp edx, [w]
            jne .LP2
        
        NEWLINE
        jmp .LP1

exit:
    mov rsp, rbp
    pop rbp
    
    ret