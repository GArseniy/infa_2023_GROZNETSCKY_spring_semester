extern io_get_hex, io_print_hex


section .bss
    a resd 1
    b resd 1
    c resd 1


section .text
global main
main:
    call io_get_hex
    mov [a], eax
    
    call io_get_hex
    mov [b], eax
    
    call io_get_hex
    mov [c], eax
    
    mov eax, [a]
    and eax, [c]
    
    not dword[c]
    
    mov ebx, [b]
    and ebx, [c]
    
    or eax, ebx
    
    call io_print_hex
      
    xor eax, eax
    ret
