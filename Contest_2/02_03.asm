extern io_get_dec, io_print_dec


section .bss
    A resd 1
    B resd 1
    C resd 1
    D resd 1
    E resd 1
    F resd 1
    

section .text
global main
main:
    call io_get_dec
    mov [A], eax
    
    call io_get_dec
    mov [B], eax
    
    call io_get_dec
    mov [C], eax
    
    call io_get_dec
    mov [D], eax
    
    call io_get_dec
    mov [E], eax
    
    call io_get_dec
    mov [F], eax
    
    
    mov eax, 0
    
    mov ecx, [E]
    add ecx, [F]
    
    imul ecx, [A]
    add eax, ecx
    
    mov ecx, [D]
    add ecx, [F]
    
    imul ecx, [B]
    add eax, ecx
    
    mov ecx, [E]
    add ecx, [D]
    
    imul ecx, [C]
    add eax, ecx
    
    mov ecx, [A]
    add ecx, [B]
    
    imul ecx, [F]
    add eax, ecx
    
    mov ecx, [A]
    add ecx, [C]
    
    imul ecx, [E]
    add eax, ecx
    
    mov ecx, [B]
    add ecx, [C]
    
    imul ecx, [D]
    add eax, ecx
    
    cdq
    mov ecx, 2
    div ecx
    
    call io_print_dec
    
    xor eax, eax
    ret
