;Algoritmo: criba de Erastostenes para hallar los primos menores
;o iguales a un numero natural dado

%include "io.inc"

section .bss
    n resd 1 ; esta variable contendra el numero al que se le quiere hallar sus primos menores

section .text

global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, [n] ; leer un numero :v
    
    sub esp, [n] ; reservar [n] bytes en la pila
    
    mov ecx, 0
    
    .loop_1: ; en este ciclo se limpia el espacio reservado en la pila, O(n)
        cmp ecx, [n]
        je .end_loop_1
        
        mov byte[esp + ecx], 1 ; marcar como (1) => primo este numero
        
        inc ecx
        jmp .loop_1
        
    .end_loop_1:
    
    mov ecx, 3
    
    .for:
        mov eax, ecx
        xor edx, edx
        mul eax ; aqui [eax] guarda el cuadrado de ecx
        cmp eax, [n]
        jge .end_for ; si el indice actual al cuadrado es mayor que el numero [n] no tiene sentido seguir        
        
        cmp byte[esp + ecx], 0 ; aqui se marca si el numero es primo (1) o compuesto (0)
        je .continue ; si el numero actual esta marcado como compuesto, se ignora y se va a la proxima iteracion
        
        mov ebx, ecx
        add ebx, ecx ; inicializar [ebx] con el doble del indice actual
        
        .for_inner:
            cmp ebx, [n]
            jge .continue
            
            mov byte[esp + ebx], 0 ; marcar este multiplo de [ecx] como compuesto
            
            add ebx, ecx ; avanzar al proximo multiplo de [ecx]
            jmp .for_inner ; nueva iteracion
            
        .continue:
        
        add ecx, 2 ; avanzar hasta el siguiente numero impar, no tiene sentido analizar los pares
        jmp .for ; nueva iteracion
        
    .end_for:
    
    PRINT_UDEC 4, 2 ; el 2 es primo, pero es par, asi que el algoritmo lo ignora ;P
    NEWLINE
    
    mov ecx, 3 ; volvemos a poner el 3 en ecx
    
    .print_loop:
        cmp ecx, [n] ; recorremos todos los impares menores e iguales que [n]
        jg .end_print_loop
        
        cmp byte[esp + ecx], 0 ; si esta marcado como [0], salta a la proxima iteracion
        je .continue_1
        
        PRINT_UDEC 4, ecx ; si no, entonces esta marcado como (1) => primo, asi que lo imprimimos y luego nueva linea
        NEWLINE
        
        .continue_1:
        add ecx, 2 ; saltar al proximo impar
        jmp .print_loop ; nueva iteracion
        
    .end_print_loop:
    
    mov esp, ebp ; limpiar la pila
    
    xor eax, eax
    ret