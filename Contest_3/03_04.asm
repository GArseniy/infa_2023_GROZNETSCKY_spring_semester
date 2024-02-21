extern io_get_udec, io_print_dec


section .bss
    a resd 11

    
section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    
    test eax, eax
    je .zero_case
    
    mov esi, 0
    
.L_convert:
    test eax, eax
    je .L_print
    
    xor edx, edx
    mov ebx, 8
    div ebx
    
    mov [a + 4 * esi], edx
    inc esi
    
    jmp .L_convert
    
    
.L_print:
    test esi, esi
    je .end
    dec esi
    
    mov eax, [a + 4 * esi]
    call io_print_dec
    
    jmp .L_print
    

.end:
    xor eax, eax
    ret


.zero_case:
    call io_print_dec
    
    jmp .end
