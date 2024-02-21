extern io_get_dec, io_print_dec, io_print_char


section .bss
    x1 resd 1
    y1 resd 1
    x2 resd 1
    y2 resd 1
    x3 resd 1
    y3 resd 1


section .text
global main
main:
    mov ebp, esp; for correct debugging

    call io_get_dec
    mov [x1], eax
    
    call io_get_dec
    mov [y1], eax
    
    call io_get_dec
    mov [x2], eax
    
    call io_get_dec
    mov [y2], eax
    
    call io_get_dec
    mov [x3], eax
    
    call io_get_dec
    mov [y3], eax
    
    
    mov ebx, [y2]
    sub ebx, [y3]
    imul ebx, [x1]
    
    mov ecx, [y3]
    sub ecx, [y1]
    imul ecx, [x2]
    
    mov edx, [y1]
    sub edx, [y2]
    imul edx, [x3]
    
    mov eax, 0
    
    add eax, ebx
    add eax, ecx
    add eax, edx
    
    cdq
    xor eax, edx
    sub eax, edx
    
    mov esi, 2
    cdq
    div esi
    
    mov edi, edx
    
    
    call io_print_dec
    
    mov eax, '.'
    call io_print_char
    
    
    mov eax, edi
    imul eax, 5
    
    call io_print_dec
    
    xor eax, eax
    ret
