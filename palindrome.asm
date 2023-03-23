; Algoritmo: dado un string separado por saltos de lineas, dice cuantos de los sub-strings
; son palindromos
%include "io.inc"

section .data
    s db "Hola", 10, "qrooq", 10, "o", 10, "ppm", 10, "pepepep", 0 ;for standard supose always null at the end
    
section .bss
    ans resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov eax, s;store the start of the string in eax
    dec eax
    
    mov ecx, 0
    mov [ans], ecx
    
    .is_pal:
        inc eax
        
        mov dl, [eax]
        cmp dl, 0
        je .end
        
        mov ebx, eax; store temporally the state of the pointer in ebx
        
        .loop:
            inc eax
            mov dl, [eax]
            
            cmp dl, 10
            je .end_loop
            
            cmp dl, 0
            je .end_loop
            
            jmp .loop
        .end_loop:
            pusha
            
            mov edx, eax
            dec edx
            
            push edx
            push ebx
            
            call is_palindrome
            
            add dword[ans], eax
            
            popa
            
            jmp .is_pal
    .end:
        mov eax, [ans]
        PRINT_UDEC 1, eax   
            
    xor eax, eax
    ret

;subroutine that checks if a string is palindrome
;params -> l, r
;l = pointer to the beginning of the string
;r = pointer to the end of the string
;returns -> eax = 1 if the string is palindrome, 0 otherwise
is_palindrome:
    pop ecx
    pop eax ;take first param
    pop ebx ;take second param
    push ecx
    
    push ebp;clear stack
    mov ebp, esp
    push edi
    push esi
    
    .loop:
        cmp eax, ebx;compare the pointers, if eax >= ebx means the string is palindrome
        jge .correct;so jumps to the .correct label and sets eax to 1
        
        mov cl, [eax];take the char in the pointer [eax]
        mov dl, [ebx];and the crar at the pointer [ebx]
        
        cmp cl, dl;compares them
        jne .incorrect;if they aren't equal the string is not palindrome so jumps to the .incorrect label
                      ;and sets eax to 0
        
        inc eax;moves forward the left pointer
        dec ebx;moves backwards the right pointer
        
        jmp .loop;jumps back to the begin of the loop
    
    .correct:
        mov eax, 1;sets eax to 1 and jumps to the end
        jmp .end
        
    .incorrect:
        mov eax, 0;sets eax to 0
    
    .end:
    
    pop esi;restore stack
    pop edi
    mov esp, ebp
    pop ebp
    ret;return to the call point