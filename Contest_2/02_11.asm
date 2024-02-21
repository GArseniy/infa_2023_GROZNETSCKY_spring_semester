extern io_get_dec, io_get_char, io_print_dec

section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_char
    
    sub eax, 'A'
    mov ebx, 7
    sub ebx, eax
    
    
    
    call io_get_dec
    mov ecx, 8
    sub ecx, eax
    
    mov eax, ecx
    mul ebx
    
    
    mov ecx, 2
    div ecx
    
    
    call io_print_dec
    
    xor eax, eax
    ret
