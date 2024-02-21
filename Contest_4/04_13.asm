extern io_get_dec, io_print_dec, io_print_char


section .data
    a dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov esi, eax
    
    call io_get_dec
    mov edi, eax
    
    call io_get_dec
    mov ebx, eax
    dec ebx
    
    
.L_count:
    test edi, edi
    je .end
    dec edi
    dec esi
    
    push esi
    push edi
    call A_n_k
    add esp, 2 * 4
    
    xchg eax, ebx
    
    cdq
    div ebx
    
    mov ebx, edx
    mov ecx, eax
    
    mov eax, [a + 4 * ecx]
    push ecx
    call io_print_dec
    pop ecx
    
    mov eax, ' '
    push ecx
    call io_print_char
    pop ecx
    
    push ecx
    call shift
    add esp, 4
    
    jmp .L_count
    
.end:    
    xor eax, eax
    ret
    
    
    
shift:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp + 8]

.L_shifting:
    cmp ecx, 9
    je .shift_end
    
    mov eax, [a + 4 * ecx + 4]
    mov [a + 4 * ecx], eax
    
    inc ecx
    jmp .L_shifting
    
.shift_end:
    leave
    ret



A_n_k:
    push ebp
    mov ebp, esp
    push ebx
    
    mov ecx, dword[ebp + 12]
    sub ecx, dword[ebp + 8]
    push ecx
    call factorial
    add esp, 4
    
    mov ebx, eax
    
    push dword[ebp + 12]
    call factorial
    add esp, 4
    
    mov edx, 0
    div ebx
    
    pop ebx
    leave
    ret



factorial:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp + 8]
    mov eax, 1
    mov ecx, 0
    
.L_mult:
    cmp ecx, edx
    je .fact_ret
    
    inc ecx
    imul eax, ecx

    jmp .L_mult

.fact_ret:
    leave
    ret