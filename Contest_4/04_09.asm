extern io_get_dec, io_print_dec


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov esi, eax
    mov edi, 0
    mov ebx, 0
    
.L_count:
    cmp esi, edi
    je .end
    inc ebx
    
    push ebx
    call is_less
    add esp, 4
    
    add edi, eax
    jmp .L_count
    
.end:
    mov eax, ebx
    call io_print_dec
    
    xor eax, eax
    ret
    
    
is_less:
    push ebp
    mov ebp, esp
    push ebx
    push edi
    push esi
    
    mov esi, [ebp + 8]
    mov ecx, 1
    mov ebx, 0
    
    cmp esi, 1
    setne bl
    
.L_sum:
    inc ecx
    
    mov edi, ecx
    imul edi, edi
    
    cmp edi, esi
    
    je .square
    ja .ret
    
    mov eax, esi
    mov edx, 0
    div ecx
    
    test edx, edx
    jne .L_sum
    
    add ebx, ecx
    add ebx, eax
    
    jmp .L_sum
    
    
.square:
    add ebx, ecx
    
.ret:
    cmp esi, ebx
    
    mov eax, 0
    seta al

    pop esi
    pop edi
    pop ebx
    leave
    ret
