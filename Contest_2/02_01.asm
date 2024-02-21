extern io_get_dec, io_print_dec, io_print_char

section .bss
    v_x resd 1
    v_y resd 1
    a_x resd 1
    a_y resd 1
    t resd 1


section .text
global main
main:
    call io_get_dec
    mov [v_x], eax

    call io_get_dec
    mov [v_y], eax
    
    call io_get_dec
    mov [a_x], eax
    
    call io_get_dec
    mov [a_y], eax
    
    call io_get_dec
    mov [t], eax
    

    imul eax, [a_x]
    add eax, [v_x]
    imul eax, [t]
    call io_print_dec
    mov eax, ' '
    call io_print_char 
        
    
    mov eax, [t]
    imul eax, [a_y]
    add eax, [v_y]
    imul eax, [t]
    call io_print_dec
    
    
    xor eax, eax
    ret
