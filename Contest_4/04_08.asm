extern io_get_udec, io_print_udec


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    mov esi, eax

    call io_get_udec
    mov edi, eax

    mov eax, esi
    
.L_count:
    push edi
    push eax
    call sum
    pop ebx
    add esp, 4
    
    add esi, eax
    
    cmp eax, ebx
    je .end
    jmp .L_count
    
.end:
    mov eax, esi
    call io_print_udec
    
    xor eax, eax
    ret


sum:
    push ebp
    mov ebp, esp
    push ebx
    
    mov ebx, 0
    mov eax, [ebp + 8]
    mov ecx, [ebp + 12]
    
.for:
    test eax, eax
    je .ret
    
    mov edx, 0
    div ecx
    
    add ebx, edx
    jmp .for
    
.ret:
    mov eax, ebx
    
    pop ebx
    leave
    ret
