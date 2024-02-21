extern io_get_dec, io_print_dec

section .bss
    a resd 1
    b resd 1
    c resd 1
    v resd 1

section .text
global main
main:
    mov ebp, esp; for correct debugging
    call io_get_dec
    mov [a], eax
    
    call io_get_dec
    mov [b], eax
    
    call io_get_dec
    mov [c], eax
    
    call io_get_dec
    mov [v], eax
    
    
    mov eax, [a]
    mul dword[b]
    
    mov ebx, edx
    
    mul dword[c]
    
    xchg eax, ebx
    mov ecx, edx
    
    mul dword[c]
    
    add ecx, eax
    
    mov eax, ebx
    mov edx, ecx
    
    div dword[v]
    
    
    call io_print_dec
    
    
    xor eax, eax
    ret