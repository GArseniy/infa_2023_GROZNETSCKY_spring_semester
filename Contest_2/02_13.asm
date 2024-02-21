extern io_get_dec, io_get_char, io_print_dec



section .bss
    x1 resd 1
    x2 resd 1
    y1 resd 1
    y2 resd 1



section .text
global main
main:
    call io_get_char
    mov [x1], eax
    
    call io_get_char
    mov [y1], eax
    
    call io_get_char
    
    call io_get_char
    mov [x2], eax
    
    call io_get_char
    mov [y2], eax
    
    
    mov eax, [x1]
    sub eax, [x2]
    
    cdq
    xor eax, edx
    sub eax, edx
    
    mov ebx, eax
    

    mov eax, [y1]
    sub eax, [y2]
    
    cdq
    xor eax, edx
    sub eax, edx
    
    add eax, ebx
    call io_print_dec

    
    xor eax, eax
    ret