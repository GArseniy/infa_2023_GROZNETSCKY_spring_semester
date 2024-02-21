extern io_get_dec, io_print_dec


YEAR equ 2011


section .bss
    X resd 1
    N resd 1
    M resd 1
    Y resd 1
    

section .text
global main
main:
    call io_get_dec
    mov [X], eax
    
    call io_get_dec
    mov [N], eax
    
    call io_get_dec
    mov [M], eax
    
    call io_get_dec
    mov [Y], eax
    
    
    mov eax, [N]
    sub eax, [M]
    
    mov edx, [Y]
    sub edx, YEAR
    
    imul eax, edx
    
    add eax, [X]
    
    call io_print_dec
      
    xor eax, eax
    ret
