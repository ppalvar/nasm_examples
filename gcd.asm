;Algoritmo: algoritmo de euclides para el maximo comun divisor

%include "io.inc"

section .bss
    n resd 1
    m resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    GET_UDEC 4, [n] ; leer el primer numero
    GET_UDEC 4, [m] ; leer el segundo numero
        
    mov eax, [n]
    push eax ; ponemos uno de los numeros en la pila
    
    mov eax, [m]
    push eax ; ponemos uno de los numeros en la pila
    
    call gcd ; llamamos a la subrutina recursiva que calcula el gcd
    
    PRINT_UDEC 4, eax ; ahora [eax] tiene el resultado de la subrutina, lo imprimimos

    mov esp, ebp
    xor eax, eax
    ret

gcd:
    push ebp
    mov ebp, esp ; inicializar una nueva pila
    
    mov eax, dword[esp + 8]  ; tomar el primer numero
    mov ebx, dword[esp + 12] ; tomar el segundo numero
    
    cmp eax, ebx ; si [eax] > [ebx], los intercambiamos, por conveniencia
    jnl .else
    
    .if:   ;a < b
        xchg eax, ebx
    .else:
        ;pass
        
    cmp ebx, 0 ; caso base de la recursion: uno de los elementos es 0. Si se cumple,retorna
    je .end
    
    xor edx, edx ; limpiar el registro edx para correctitud en los calculos  
    div ebx ; dividimos a/b, con esto tenemos que, dado que a = b*q + R donde q es el cociente y R el resto que se 
            ; guarda en edx, luego gcd(a, b) = gcd(b, R)
    
    push edx  ;poner R en la pila
    push ebx  ;poner b en la pila
    
    call gcd ; llamamos recursivamente con los nuevos parametros
    
    .end: ; aqui, si se cumple el caso base, [eax] contiene el maximo comun divisor de a y b
    
    mov esp, ebp ; limpiamos la pila y retornamos
    pop ebp
    ret