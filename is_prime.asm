;Algoritmo: chequeador de primalidad
%include "io.inc"

section .bss
    n resd 1
    
section .data
    p db "Prime",0
    np db "Not Prime", 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    GET_UDEC 4, [n] ; leer un numero
    
    mov eax, [n]
    mov ecx, eax ; iniciar un contador en n
    
    cmp eax, 2 ; si n = 2, es primo
    je .prime
    
    cmp eax, 1 ; si n = 1, no es primo por definicion
    je .not_prime
    
    .is_prime:
        dec ecx ; decrementar el contador con n = n - 1
        
        mov ebx, eax ; guardar en [ebx] el valor de n temporalmente
        mov edx, 0 ; limpiar [edx] para calcular correctamente
        
        div ecx ; dividir n/[ecx]
        
        mov eax, ebx ; restaurar el valor de n hacia [eax]
        
        cmp edx, 0 ; si el resto de la division es 0, no es primo
        je .not_prime
        
        cmp ecx, 2 ; si el contador llego a dos, es primo, ya que no hay otro posible divisor
        je .prime
        
        jmp .is_prime ; nueva iteracion
    
    .not_prime:
        PRINT_STRING np
        jmp .end
    .prime:
        PRINT_STRING p
        jmp .end
     
    .end:
    xor eax, eax
    ret