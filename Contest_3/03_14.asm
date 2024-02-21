extern io_get_dec, io_print_dec


section .bss
    n resd 1
    k resd 1
    max resd 1
    min resd 1
    len resd 1
    

section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    
    call io_get_dec
    mov [n], eax
    
    call io_get_dec
    mov [k], eax
    
    
    cmp dword[n], 0
    mov eax, 0
    je .end
    
    
    mov dword[len], 32
    mov eax, [n]
    
.L_len_1:
    dec dword[len]
    cdq
    
    test edx, edx
    jne .pre_count
    
    sal eax, 1
    jmp .L_len_1
    

.pre_count:
    mov eax, [k]
    cmp [len], eax
    
    mov eax, 0
    jb .end
    
    mov eax, 1
    je .end
    
    mov eax, [n]
    inc eax
    
    mov cl, [len]
    add cl, 2
    sar eax, cl
    
    mov eax, [len]
    adc eax, 0
    
    cmp dword[k], 0
    je .end
    
    
.l_main_algorithm:
    mov ecx, [k]
    dec ecx
    
    mov eax, 0
    
.L_perm:
    inc ecx
    cmp [len], ecx
    je .smart_count
    
    cmp [k], ecx
    je .inc_eax
    
    mov ebx, ecx
    sub ebx, [k]
    
    cmp ebx, [k]
    jae .l_max
    jmp .l_min

.l_max:
    mov [max], ebx
    mov ebx, [k]
    mov [min], ebx

    jmp .l_perm_continue

.l_min:
    mov [min], ebx
    mov ebx, [k]
    mov [max], ebx

    jmp .l_perm_continue

.l_perm_continue:
    mov edx, [max]
    inc edx
    
    mov edi, edx
    mov esi, 1
    
.l_factoring:
    inc edi
    inc esi
    
    cmp edi, ecx
    ja .C_n_k
    
    push eax
    mov eax, edx
    
    imul edi
    idiv esi
    
    mov edx, eax
    pop eax
    
    jmp .l_factoring


.smart_count:
    push eax
    mov eax, 0
    
    mov edx, 0
    push edx
    
    mov cl, 32
    sub cl, [len]
    
    mov ebx, [n]
    sal ebx, cl

.L_process_number:
    mov ecx, dword[len]
    cmp dword[k], ecx
    je .happy_end
    
    cmp dword[k], 0
    je .l_special
    
    dec dword[k]
    dec dword[len]
    
    sal ebx, 1
    jnc .L_process_number

    pop edx
    mov edx, -1
    push edx

.l_perm1:
    cmp dword[k], 0
    je .l_special_inc
    
    mov ecx, [len]
    sub ecx, [k]
    
    cmp ecx, [k]
    jae .l_max1
    jmp .l_min1

.l_max1:
    mov [max], ecx
    mov ecx, [k]
    mov [min], ecx

    jmp .l_perm_continue1

.l_min1:
    mov [min], ecx
    mov ecx, [k]
    mov [max], ecx

    jmp .l_perm_continue1

.l_perm_continue1:
    mov edx, [max]
    inc edx
    
    mov edi, edx
    mov esi, 1
    
.l_factoring1:
    inc edi
    inc esi
    
    cmp edi, [len]
    ja .C_n_k1
    
    mov ecx, eax
    mov eax, edx
    
    imul edi
    idiv esi
    
    mov edx, eax
    mov eax, ecx
    
    jmp .l_factoring1

    
.end:
    call io_print_dec

    xor eax, eax
    ret
    
    
.inc_eax:
    inc eax
    jmp .L_perm
    
    
.C_n_k:
    add eax, edx
    jmp .L_perm
    
    
.C_n_k1:
    add eax, edx
    inc dword[k]
    jmp .L_process_number

 
 .l_special_inc:
    mov edx, 1
    jmp .C_n_k1
 
 
 .l_special:
    cmp dword[len], 0
    je .happy_end
    
    sal ebx, 1
    jnc .bad_end
    
    dec dword[len]
    jmp .l_special
    
    
.happy_end:
    pop ebx
    pop ebx
    add eax, ebx
    inc eax
    
    jmp .end
    
    
.bad_end:
    pop ebx
    and eax, ebx
    
    pop ebx
    add eax, ebx
    
    jmp .end
