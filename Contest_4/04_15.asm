extern io_get_udec, io_print_udec


section .text
global main
main:
    mov ebp, esp; for correct debugging
    call io_get_udec
    mov edi, eax
    
    call io_get_udec
    mov esi, eax
    
.L_search:
    push esi
    push edi
    
    call is_lucky
    
    add esp, 8
    
    test eax, eax
    je .end
    
    inc edi
    jmp .L_search
    
.end:
    mov eax, edi

    call io_print_udec
    
    xor eax, eax
    ret
    
    
    
is_lucky:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    
    
    push dword[ebp + 12]
    push dword[ebp + 8]
    
    call len
    add esp, 2 * 4
    
    mov edx, 0
    inc eax
    mov ecx, 2
    div ecx
    
    mov esi, eax
    
    mov ecx, [ebp + 12]
    mov eax, [ebp + 8]
    
    mov ebx, 0
    
.is_lucky_sum:
    mov edx, 0
    div ecx
    
    add ebx, edx
    
    dec esi
    test esi, esi
    jne .positive
    
    imul ebx, -1
    
.positive:
    test eax, eax
    jne .is_lucky_sum
    
    mov eax, ebx
    
    pop esi
    pop ebx
    leave
    ret



len:
    push ebp
    mov ebp, esp
    push ebx
    
    mov ebx, 0
    mov eax, [ebp + 8]
    mov ecx, [ebp + 12]
    
.L_len_count:
    mov edx, 0
    div ecx
    
    inc ebx
    test eax, eax
    jne .L_len_count
    
    mov eax, ebx
    
    pop ebx
    leave
    ret
