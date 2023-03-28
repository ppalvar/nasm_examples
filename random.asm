%include "io64.inc"

section .data
    seed dq 0   ; guarda la semilla para generar nuestro numero aleatorio

section .text
    global CMAIN

CMAIN:
    mov rbp, rsp; for correct debugging
    
    call RANDOM.rand ; Llama a la funcion que va a generar el numero aleatorio
    
    PRINT_UDEC 1, seed  ; Muestra el numero en la consola
    
    xor rax, rax
    ret
    
RANDOM:
    
    .rand:  ; Guarda en `eax` un numero aleatorio
    
        ; Toma la hora del sistema en milisegundos como valor inicial de la semilla
        ; 0x80 funcion de llamada al sistema para obtener la hora actual
        mov rax, 0x2
        xor rbx, rbx
        int 0x80    
        mov [seed], rax
        
        ; Inicializo las variable de mi ecuacion
        mov rax, [seed]     ; A
        mov rbx, 0x343FD    ; B
        mov rcx, 0x269ec3   ; C
        mov rdx, 0x7FFFFFFF ; D
        
        ; Generar un numero aleatorio se basa en la siguiente ecuacion
        ; Xn+1 = (A*B + C) % D
        
        mul rbx         ; Efectua `A*B`
        add rax, rcx    ; Efectua `A+C`
        mov [seed], rax ; Efectua `seed = A`
        div rbx         ; Efectua `A /= B` y `D = A % B` donde % es el operador de modulo
        
        ret        
        
