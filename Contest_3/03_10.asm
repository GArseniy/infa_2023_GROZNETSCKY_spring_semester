extern io_get_dec, io_print_dec


section .text
global main
main:
    mov ebp, esp; for correct debugging

    call io_get_dec
    mov esi, eax
    
    mov ecx, 1

.L_div:
    inc ecx
    
    mov ebx, ecx
    imul ebx, ebx
    
    cmp ebx, esi
    je .end
    ja .prime
    
    mov edx, 0
    mov eax, esi
    div ecx
    
    test edx, edx
    je .end
    jmp .L_div
    

.prime:
    mov eax, 1
    call io_print_dec
    
    xor eax, eax
    ret

    
.end:
    mov edx, 0
    mov eax, esi
    div ecx

    call io_print_dec
    
    xor eax, eax
    ret
