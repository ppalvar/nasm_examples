; Algoritmo: factorial iterativo

%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    xor eax, eax
    
    GET_UDEC 4, eax ; leer un numero n
    
    push eax ; ponerlo en la pila
    call factorial ; llamar la subrutina que calculara su factorial
     
    add esp, 4 ; liberar un byte de memoria de la pila
    
    PRINT_UDEC 4, eax ; imprimir el resultado
    
    xor eax, eax
    ret
    
factorial:
    push ebp ; inicializar nueva pila
    mov ebp, esp
    
    mov ecx, [ebp + 8] ; tomar n de la pila
    mov eax, 1 ; base para factorial: factorial(0) = 1

    cmp ecx, 0 ; si se cumple la base, salta hasta el final
    jle .end
    
    .calc:
        mul ecx ; multiplicar el acumulado por un n-1
        
        jo .overflow ; si hay overflow, parar e imprimir una advertencia
        
        dec ecx ; hacer que n = n-1
        jz .end ; si es 0, terminar el ciclo
        
        jmp .calc ; nueva iteracion
        
    .overflow: ; advertencia en caso de overflow
        PRINT_STRING "OVERFLOW"
        NEWLINE
    .end:
    
    mov esp, ebp ; limpiar la pila y retornar
    pop ebp
    ret