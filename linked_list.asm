; Algorithm: Linked list
; usage: 

; add_node value, head, tail
; value is the actual value you want to store in the node, head and tail are variables used to store the head
; and the tail of the list

; find value, head, tail
; searches for 'value' in the list. If its found, then eax = 1, else eax = 0

; index id, head, tail
; puts in eax the value of the list at the 'id' index, on 0-based indexation. If the index is out of range, segfault

; delete value, head, tail
; searches for the value in the list and deletes it. if not found, doesn't do anything

; delete_idx idx, head, tail
; searches for the 'idx' index in the list and deletes it. if not found, segfault :'V


%macro add_node 3
    sub esp, 12 ; reserve 12 bytes, 4 for the pointer to the next node, 4 for the pointer to the previous node
                ; and 4 for the value that will hold this node
    
    mov edx, dword[%3]
    cmp edx, 0           
    
    jne .skip_head_creation
    
    mov dword[%2], esp ; initialize a new list
    mov dword[%3], esp
    
    .skip_head_creation:
    
    mov edx, dword[%3]
    mov dword[edx], esp ; update next
    
    mov dword[%3], esp ; update tail
    
    ; update last node
    mov dword[esp], 0       ; last node points to null
    mov dword[esp + 4], edx ; previus set to edx
    mov edx, %1             
    mov dword[esp + 8], edx ; add the value to the node
%endmacro


%macro find 3
    push %1
    mov eax, 0
    
    push %1
    push dword[%2]
       
    call search
    
    add esp, 8
    pop %1
%endmacro


%macro index 3
    push %1
    mov eax, 0
    
    push %1
    push dword[%2]
    call get_index
    
    add esp, 8
    pop %1
%endmacro


%macro delete 3
    push %1
    mov eax, 0
    
    push %1
    push dword[%2]
       
    call search_
    add esp, 8
    
    push dword[%3]
    push dword[%2]
    push eax
    
    call delete_address
    
    add esp, 12
    pop %1
%endmacro


%macro delete_idx 3
    push %1
    mov eax, 0
    
    push %1
    push dword[%2]
       
    call get_index_
    add esp, 8
    
    push dword[%3]
    push dword[%2]
    push eax
    
    call delete_address
    
    add esp, 12
    pop %1
%endmacro


%include "io.inc"


section .data
    head dd 0
    tail dd 0
    n dd 0


section .text
global CMAIN


; params: 
; 1-> memory address to the current node
; 2-> the value you are searching
search:
    push ebp
    mov ebp, esp
    
    mov edx, dword[esp + 8] ; memory address to the current node
    
    mov ebx, dword[edx + 8]
    cmp ebx, dword[esp + 12]
    
    mov eax, 1
    
    je .end_search
    
    mov eax, 0
    
    cmp dword[edx], 0
    je .end_search
    
    .skip_step:
        mov ebx, dword[esp + 12]
        push ebx
        mov edx, dword[edx]
        push edx
        call search
    
    .end_search:
    mov esp, ebp
    pop ebp
    ret

; params: 
; 1-> memory address to the current node
; 2-> the index you are looking for
get_index:
    push ebp
    mov ebp, esp
    
    mov edx, dword[esp + 8]
    mov ecx, dword[esp + 12]
    
    cmp ecx, 0
    jg .get_next_index
    
    mov eax, dword[edx + 8]
    
    jmp .index_already_found
    
    .get_next_index:
        dec ecx
        mov edx, dword[edx]
        push ecx
        push edx
        call get_index
    
    .index_already_found:
    
    mov esp, ebp
    pop ebp
    ret

;this version returns the memory address of the node
; params: 
; 1-> memory address to the current node
; 2-> the value you are searching
search_:
    push ebp
    mov ebp, esp
    
    mov edx, dword[esp + 8] ; memory address to the current node
    
    mov ebx, dword[edx + 8]
    cmp ebx, dword[esp + 12]
    
    mov eax, edx
    
    je .end_search
    
    mov eax, 0
    
    cmp dword[edx], 0
    je .end_search
    
    .skip_step:
        mov ebx, dword[esp + 12]
        push ebx
        mov edx, dword[edx]
        push edx
        call search_
    
    .end_search:
    mov esp, ebp
    pop ebp
    ret

;this version returns the memory address of the node
; params: 
; 1-> memory address to the current node
; 2-> the index you are looking for
get_index_:
    push ebp
    mov ebp, esp
    
    mov edx, dword[esp + 8]
    mov ecx, dword[esp + 12]
    
    cmp ecx, 0
    jg .get_next_index
    
    mov eax, edx
    
    jmp .index_already_found
    
    .get_next_index:
        dec ecx
        mov edx, dword[edx]
        push ecx
        push edx
        call get_index_
    
    .index_already_found:
    
    mov esp, ebp
    pop ebp
    ret

; params:
; 1-> memory address of the node you want to delete
; 2-> the head of the list
; 3-> the tail of the list
delete_address:
    push ebp
    mov ebp, esp
    
    mov eax, dword[esp + 8]
    
    cmp eax, 0
    je .dont_delete
    
    mov edx, dword[esp + 12]
    cmp edx, dword[esp + 16]
    je .delete_single_node
    
    cmp eax, dword[esp + 12]
    je .delete_head
    
    cmp eax, dword[esp + 16]
    je .delete_tail
    
    mov edx, dword[eax + 4] ; the previous node
    mov ebx, dword[eax]     ; the next node
    
    mov dword[edx], ebx
    mov dword[ebx + 4], edx
    
    jmp .dont_delete
    
    .delete_head:
        mov edx, dword[eax]
        mov dword[esp + 12], edx
        jmp .dont_delete
    
    .delete_tail:
        mov edx, dword[eax + 4]
        mov dword[esp + 16], edx
        mov dword[edx], 0
        jmp .dont_delete
        
    .delete_single_node:
        mov dword[esp + 12], 0
        mov dword[esp + 16], 0
        jmp .dont_delete
        
    .dont_delete:
    mov esp, ebp
    pop ebp
    ret
    
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, [n]
    
    mov ecx, [n]

    .loop:
        cmp ecx, 0
        je .end_loop
        
        GET_UDEC 4, ebx

        add_node ebx, head, tail
        
        dec ecx
        jmp .loop
    
    .end_loop:
    
    mov ecx, 0
    
    .loop1:
        cmp ecx, dword[n]
        je .end_loop1
        
        index ecx, head, tail
        
        PRINT_UDEC 4, eax
        NEWLINE
        
        inc ecx
        jmp .loop1
        
    .end_loop1:

    mov esp, ebp
    xor eax, eax
    ret
