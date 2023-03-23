%include "io.inc"

%define mid dword[ebp + 12]
%define end dword[ebp + 16]

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    GET_UDEC 4, edx ; read the length of the array
    
    mov ecx, 0; start a counter
    
    .read_loop:
        cmp ecx, edx ; while the counter is less than the length of the array
        je .end_read_loop
        
        GET_UDEC 4, ebx ;read a number
        push ebx ; and store it to the stack
        
        inc ecx ; then, add 1 to the counter
        jmp .read_loop ; and begin the loop again
        
    .end_read_loop:

    mov ebx, esp ;store the current point of the stack, where is stored the array
    
    push edx ; store in the stack the lenght of the array
    push ebx ; store in the stack the memory address where the array begins
    
    call m_sort ; call the method that will sort the array
    
    add esp, 8 ; free 8 bytes from the stack
    
    mov ecx, 0 ; start a counter at 0
    
    .loop:
        cmp ecx, edx ; if the counter is equal to the lenght of the array, break
        je .end_loop
        
        pop eax ; take an element of the array
        
        PRINT_UDEC 4, eax ; print it
        NEWLINE
        
        inc ecx ; add 1 to the counter
        jmp .loop ; new iteration
    .end_loop:
    
    xor eax, eax ; free the stack and return
    mov esp, ebp
    ret
    
m_sort:
    push ebp ; start a new brand stack
    mov ebp, esp
    
    mov esi, dword[esp +  8] ; take a pointer to the beginning of the array
    mov ecx, dword[esp + 12] ; take the lenght of the array
    
    cmp ecx, 1 ; if the lenght is 1, the array is sorted so go to the end
    je .end
    
    mov eax, ecx ; calculate the middle of the array, here eax has the length of the first half
    shr eax, 1
    
    pusha ; save all registers
    
    push eax ; store the lenght of the first half of the array in the stack
    push esi ; store the pointer to the array
    
    call m_sort ; sort the first half
    
    add esp, 8 ; free the last 8 bytes of the stack
    
    popa ; restore all the registers
    
    mov edx, esi 
    mov ebx, eax
    shl ebx, 2
    add edx, ebx ; add to the memory address of the ponter 4*m so we have the memory address of the second half
    
    pusha ; save all registers
    
    mov ebx, ecx
    sub ebx, eax ; calculate the lenght of the second half of the array
    
    push ebx ; store in the stack the memory address of the second half of the array
    push edx ; store in the stack the lenght of the second half of the array
    
    call m_sort ; sort the second half of the array
    
    add esp, 8 ; free 8 bytes of the stack
    
    popa ; restore all registers
        
    ;save to the stack:
    push ecx ; the lenght of the array
    push eax ; the lenght of the first half
    push esi ; the memory addres of the array
    
    call merge ; merge the two sorted halves
    
    .end:
    
    mov esp, ebp ; clear the stack and return
    pop ebp
    ret


merge:
    push ebp
    mov ebp, esp ; start a new brand stack
    
    ;take from the stack:
    mov esi, dword[ebp + 8] ; the memory addres of the array
    ; mid = the lenght of the first half
    ; end = the lenght of the array
    
    mov ebx, 0 ; start a counter at 0 for the left half
    mov edx, mid ; and another at the middle of the array for the rigth half
    
    mov ecx, 0 ; start a counter at 0, to count all the items of the array
    
    .loop:
        cmp ecx, end ; if the [ecx] counter is at the end of the array, end the loop
        je .end_loop
        
        cmp ebx, mid ; if the left counter is at the middle, take an item from the right
        jge .take_right
        
        cmp edx, end ; if the right counter is at the end, take an item from the left
        jge .take_left
        
        mov eax, dword[esi + ebx * 4] ; move left to a register
        cmp eax, dword[esi + edx * 4] ; compare left and right values
        
        jg .take_right ; if the item on the left is greater, take the one in the right. else, take the one on the left
        
        .take_left:
            push dword[esi + ebx * 4] ; take an item from the left and increase the counter
            inc ebx
            jmp .back_to_loop
            
        .take_right:
            push dword[esi + edx * 4] ; take an item from the right and increase the counter
            inc edx
            jmp .back_to_loop
        
        .back_to_loop:
            inc ecx ; increase the master counter and go back to the loop
            jmp .loop
    
    .end_loop:
    
    ; now, the array is sorted and stored in the stack, so we have to put it back to the origin
    
    mov ecx, end ; start a counter at the end of the array (beginning of the stack)
    
    .restore:
        cmp ecx, 0 ; if the counter reaches 0, break the loop
        je .end
        
        pop eax ; take an item from the stack
        mov dword[esi + ecx * 4 - 4], eax ; put it in the right position on the memory address of the array
        
        dec ecx ; decrease the counter and back to the loop
        jmp .restore
    
    .end:
    
    mov esp, ebp ; clear the stack and return
    pop ebp
    ret