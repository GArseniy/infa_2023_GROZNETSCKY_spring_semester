extern io_get_dec, io_print_dec, io_print_char


section .text
global main
main:   
    push ebp
    mov ebp, esp
    
    call io_get_dec
    mov ebx, eax
    
    mov esi, 0
    
.L_read:
    inc esi
    cmp esi, ebx
    ja .process
    
    call io_get_dec
    push eax
    
    mov eax, 1
    push eax
    
    jmp .L_read


.process:
    mov edx, esp

    mov eax, comparator
    push eax
    
    mov eax, 8
    push eax
    
    push ebx
    push edx
    
    call sort
    
    add esp, 4 * 4
    

.L_print:
    cmp ebx, 0
    je .end
    dec ebx
    
    pop edi
    pop eax
    
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
    
    jmp .L_print

    
.end:
    xor eax, eax
    leave
    ret



comparator:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    
    mov ebx, [ebp + 8]
    mov ecx, [ebp + 12]
    
    mov eax, [ebx + 4]
    mul dword[ecx]
    
    mov esi, eax
    mov edi, edx
    
    mov eax, [ebx]
    mul dword[ecx + 4] 
    
    cmp edi, edx
    jg .comparator_above
    jl .comparator_belong
    
    cmp esi, eax
    jg .comparator_above
    jl .comparator_belong
    
    
    mov ebx, [ebp + 8]
    mov ecx, [ebp + 12]
    
    mov eax, [ebx + 4]
    mov edx, [ecx + 4]
    
    cmp eax, edx
    jg .comparator_above
    jl .comparator_belong
    
    mov eax, 0
    jmp .comparator_ret

.comparator_above:
    mov eax, 1
    jmp .comparator_ret

.comparator_belong:
    mov eax, -1
    jmp .comparator_ret
    
.comparator_ret:
    pop ebx
    pop edi
    pop esi
    leave
    ret


swap:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    
    
    mov esi, [ebp + 8]
    mov edi, [ebp + 12]
    
    mov eax, [esi]
    mov ebx, [edi]
    mov [esi], ebx
    mov [edi], eax
    
    mov eax, [esi + 4]
    mov ebx, [edi + 4]
    mov [esi + 4], ebx
    mov [edi + 4], eax
    
    
    pop ebx
    pop edi
    pop esi
    leave
    ret
    

sort:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 12]
    dec eax
    push eax
    
    mov eax, 0
    push eax
    
    push dword[ebp + 20]
    push dword[ebp + 16]
    push dword[ebp + 8]
    
    call qsort
    add esp, 4 * 5

    leave
    ret


qsort:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    
    mov esi, [ebp + 20]
    mov edi, [ebp + 24]
    
    mov eax, esi
    add eax, edi
    mov edx, 0
    mov ebx, 2
    div ebx
    
    mov ebx, [ebp + 12]
    imul ebx, eax
    add ebx, [ebp + 8]
    
    push dword[ebx + 4]
    push dword[ebx]
    
    mov ebx, esp
    
.qsort_do:

.qsort_i:
    mov ecx, [ebp + 12]
    imul ecx, esi
    add ecx, [ebp + 8]
    
    push ebx
    push ecx
    call dword[ebp + 16]
    add esp, 2 * 4
    
    cmp eax, -1
    jne .qsort_j
    
    inc esi
    jmp .qsort_i
    
.qsort_j:
    mov ecx, [ebp + 12]
    imul ecx, edi
    add ecx, [ebp + 8]
    
    push ebx
    push ecx
    call dword[ebp + 16]
    add esp, 2 * 4
    
    cmp eax, 1
    jne .qsort_main_cond
    
    dec edi
    jmp .qsort_j
    
.qsort_main_cond:
    cmp esi, edi
    jg .qsort_do_cond
    
    mov ecx, [ebp + 12]
    imul ecx, edi
    add ecx, [ebp + 8]
    push ecx
    
    mov ecx, [ebp + 12]
    imul ecx, esi
    add ecx, [ebp + 8]
    push ecx
    
    call dword[ebp + 16]
    
    pop ecx
    pop edx
    
    cmp eax, 1
    jne .qsort_skip_swap
    
    push ecx
    push edx
    call swap
    add esp, 4 * 2
    
.qsort_skip_swap:
    inc esi
    dec edi
    
.qsort_do_cond:
    cmp esi, edi
    jng .qsort_do
    
    
    cmp esi, [ebp + 24]
    jge .qsort_skip_i
    
    push dword[ebp + 24]
    push esi
    push dword[ebp + 16]
    push dword[ebp + 12]
    push dword[ebp + 8]
    
    call qsort
    add esp, 4 * 5
    
    
.qsort_skip_i:
    cmp [ebp + 20], edi
    jge .qsort_skip_j
    
    push edi
    push dword[ebp + 20]
    push dword[ebp + 16]
    push dword[ebp + 12]
    push dword[ebp + 8]
    
    call qsort
    add esp, 4 * 5
    
    
.qsort_skip_j:
    add esp, 2 * 4
    pop edi
    pop esi
    pop ebx
    leave
    ret
